//
//  BaseController.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 08/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//all functions need context as (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
class DataManager  {
    static let shared = DataManager()
    
    private init() {}
    
    func loadTransactions(inMonth date: Date, context: NSManagedObjectContext) -> [Transaction]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        
        let dates = firstAndLastDay(inMonth: date)
        let p1 = NSPredicate(format: "date >= %@", dates[0] as NSDate)
        let p2 = NSPredicate(format: "date <= %@", dates[1] as NSDate)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let result = try context.fetch(request) as! [Transaction]
            return result
        } catch {
            print("Failed")
        }
        return nil
    }
    
    func loadTransactions(beforeMonth date: Date, context: NSManagedObjectContext) -> [Transaction]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        
        let dates = firstAndLastDay(inMonth: date)
        request.predicate = NSPredicate(format: "date <= %@", dates[0] as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let result = try context.fetch(request) as! [Transaction]
            return result
        } catch {
            print("Failed")
        }
        return nil
    }
    
    func loadRepeated(onlyActive: Bool, context: NSManagedObjectContext) -> [Repeated]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Repeated")
        
        /*if onlyActive {
            let today = Date()
            let p1 = NSPredicate(format: "from <= %@", today as NSDate)
            let p2 = NSPredicate(format: "to >= %@", today as NSDate)
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
        }*/
        if onlyActive {
            let today = Date()
            request.predicate = NSPredicate(format: "to >= %@", today as NSDate)
        }
        request.sortDescriptors = [NSSortDescriptor(key: "to", ascending: false)]
        
        print("Loaded repeated")
        do {
            let result = try context.fetch(request) as! [Repeated]
            return result
        } catch {
            print("Failed")
        }
        return nil
    }
    
    func addRepeated(_ name: String, _ amount: Double, _ from: Date, _ to: Date, _ period: Int, monthly: Bool, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Repeated", in: context)
        let repeated = NSManagedObject(entity: entity!, insertInto: context)
        
        repeated.setValue(name, forKey: "name")
        repeated.setValue(amount, forKey: "amount")
        repeated.setValue(from, forKey: "from")
        repeated.setValue(to, forKey: "to")
        repeated.setValue(period, forKey: "period")
        repeated.setValue(monthly, forKey: "monthly")
        repeated.setValue(nil, forKey: "lastUpdated")
    }
    
    func delete(_ model: NSManagedObject, context: NSManagedObjectContext){
        context.delete(model)
        print("Deleted!")
    }
    
    func delete(_ models: [NSManagedObject], context: NSManagedObjectContext){
        for model in models {
            context.delete(model)
        }
        print("Deleted!")
    }
    
    func firstAndLastDay(inMonth date: Date) -> [Date] {
        var startOfMonth : Date = Date()
        var lengthOfMonth : TimeInterval = 0
        let _ = Calendar.current.dateInterval(of: .month, start: &startOfMonth, interval: &lengthOfMonth, for: date)
        let endOfMonth = startOfMonth.addingTimeInterval(lengthOfMonth - 1)
        return [startOfMonth, endOfMonth]
    }
    
    func deleteAll(entity : String, context: NSManagedObjectContext){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            let results = try context.fetch(request)
            for managedObject in results
            {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    func deleteThisMonth(entity : String, context: NSManagedObjectContext){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let dates = firstAndLastDay(inMonth: Date())
        let p1 = NSPredicate(format: "date >= %@", dates[0] as NSDate)
        let p2 = NSPredicate(format: "date <= %@", dates[1] as NSDate)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
        
        do {
            let results = try context.fetch(request)
            for managedObject in results
            {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
}











