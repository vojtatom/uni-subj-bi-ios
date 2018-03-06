//
//  ModifyRepeatedViewModel.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 11/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class RepeatedModifyViewModel : BaseViewModel {
    
    let context : NSManagedObjectContext
    let model : Repeated
    
    let namePlaceholder = "name"
    let amountPlaceholder = "0"
    let periodPlaceholder = "1"
    
    public private(set) var saved = false
    
    var from : String {
        get {
            if let date = model.from {
                return Time.dateFormatter.string(from: date)
            }
            return Placeholders.none.rawValue
        }
    }
    
    var to : String {
        get {
            if let date = model.to {
                return Time.dateFormatter.string(from: date)
            }
            return Placeholders.none.rawValue
        }
    }
    
    init(context: NSManagedObjectContext?, repeated: Repeated?){
        self.context = context ?? (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if let r = repeated {
            self.saved = true
            self.model = r
        } else {
            self.model = Repeated(context: self.context)
            self.model.period = 1
            self.model.from = Date()
            self.model.to = Date()
        }
        super.init()
    }
    
    func validate() -> Bool{
        if (model.amount <= 0 || model.name == "" || model.period <= 0 || model.name == Placeholders.none.rawValue){
            return false
        }
        
        if let from = model.from, let to = model.to {
            if from > to {
                return false
            }
        } else {
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
