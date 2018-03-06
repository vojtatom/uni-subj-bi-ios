//
//  RepeatedDetailViewModel.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 11/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class RepeatedDetailViewModel : BaseViewModel {
    
    let model: Repeated
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
    
    var from : String {
        get {
            if let date = model.from {
                return "from " + Time.dateFormatter.string(from: date)
            }
            return Placeholders.none.rawValue
        }
    }
    
    var to : String {
        get {
            if let date = model.to {
                return "to " + Time.dateFormatter.string(from: date)
            }
            return Placeholders.none.rawValue
        }
    }
    
    var period : String {
        get {
            if model.monthly {
                if model.period == 1 {
                    return "every month"
                } else {
                    return "every \(model.period) months"
                }
            } else {
                if model.period == 1 {
                    return "every day"
                } else {
                    return "every \(model.period) days"
                }
            }
        }
    }
    
    init (model: Repeated, context: NSManagedObjectContext) {
        self.model = model
        self.context = context
        super.init()
    }
}
