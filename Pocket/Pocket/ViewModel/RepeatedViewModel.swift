//
//  RepeatedViewModel.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 09/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class RepeatedViewModel : BaseViewModel {
    
    var allRepeated : [Repeated?]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override init () {
        allRepeated = [nil]
        super.init()
        self.update()
    }
    
    func nameFor(index: Int) -> String {
        return allRepeated[index]?.name ?? Placeholders.none.rawValue
    }
    
    func amountFor(index: Int) -> String {
        if let amount = allRepeated[index]?.amount, let isExpense = allRepeated[index]?.isExpense {
            return (isExpense ? "-" : "") + String(amount) + BaseViewModel.currency
        } else {
            return Placeholders.none.rawValue
        }
    }
    
    func dateFromFor(index: Int) -> String {
        if let date = allRepeated[index]?.from {
            return "from " + Time.dateFormatter.string(from: date)
        } else {
            return Placeholders.none.rawValue
        }
    }
    
    func dateToFor(index: Int) -> String {
        if let date = allRepeated[index]?.to {
            return "to " + Time.dateFormatter.string(from: date)
        } else {
            return Placeholders.none.rawValue
        }
    }
    
    func isExpenseFor(index: Int) -> Bool {
        return allRepeated[index]?.isExpense ?? false
    }
    
    func update() {
        if let repeated = DataManager.shared.loadRepeated(onlyActive: false, context: context) {
            self.allRepeated = repeated
        } else {
            self.allRepeated = [nil]
        }
    }
    
    func delete(index: Int) -> Bool {
        guard let toDelete = allRepeated[index] else { return false }
        allRepeated.remove(at: index)
        DataManager.shared.delete(toDelete, context: context)
        return true
    }
    
}

