//
//  ModifyTransactionViewModel.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 11/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TransactionModifyViewModel : BaseViewModel {
    
    let context : NSManagedObjectContext
    let model : Transaction
    
    let namePlaceholder = "name"
    let amountPlaceholder = "0"
    
    public private(set) var saved = false
    
    var amount : String {
        get {
            return String(model.amount)
        }
    }
    
    var date : String {
        get {
            if let date = model.date {
                return Time.dateFormatter.string(from: date)
            }
            return Placeholders.none.rawValue
        }
    }
    
    init(context: NSManagedObjectContext?, transaction: Transaction?){
        self.context = context ?? (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        if let t = transaction {
            self.saved = true
            self.model = t
        } else {
            self.model = Transaction(context: self.context)
            self.model.date = Date()
        }
        
        super.init()
    }
    
    func validate() -> Bool{
        if (model.amount <= 0 || model.name == "" || model.name == Placeholders.none.rawValue){
            return false
        }

        saved = true
        return true
    }
    
    func remove() {
        if !saved{
            DataManager.shared.delete(model, context: context)
        }
    }
    
    func delete() {
        DataManager.shared.delete(model, context: context)
    }
}
