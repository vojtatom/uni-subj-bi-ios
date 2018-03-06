//
//  TransactionDetailViewModel.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 11/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TransactionDetailViewModel : BaseViewModel {
    
    let model: Transaction
    let context: NSManagedObjectContext
    
    var name : String {
        get {
            return model.name ?? Placeholders.none.rawValue
        }
    }
    
    var amount : String {
        get {
            return (model.isExpense ? "-" : "") + String(model.amount) + BaseViewModel.currency
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
    
    var hasRepeated : Bool {
        get {
            if model.repeated == nil {
                return false
            }
            return true
        }
    }
    
    init (model: Transaction, context: NSManagedObjectContext) {
        self.model = model
        self.context = context
        super.init()
    }
}
