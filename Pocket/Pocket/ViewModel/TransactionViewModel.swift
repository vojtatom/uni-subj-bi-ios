//
//  HistoryViewModel.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 09/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TransactionViewModel  : BaseViewModel {
    
    var monthTransactions : [Transaction?]
    var month : Date
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var monthName : String?
    
    init (monthWithDate month : Date) {
        self.month = month
        self.monthTransactions = [nil]
        super.init()
        self.update()
    }
    
    func nameFor(index: Int) -> String {
        return monthTransactions[index]?.name ?? Placeholders.none.rawValue
    }
    
    func amountFor(index: Int) -> String {
        if let amount = monthTransactions[index]?.amount, let isExpense = monthTransactions[index]?.isExpense {
            return (isExpense ? "-" : "") + String(amount) + BaseViewModel.currency
        } else {
            return Placeholders.none.rawValue
        }
    }
    
    func dateFor(index: Int) -> String {
        if let date = monthTransactions[index]?.date {
            return Time.dateFormatter.string(from: date)
        } else {
            return Placeholders.none.rawValue
        }
    }
    
    func isExpenseFor(index: Int) -> Bool {
        return monthTransactions[index]?.isExpense ?? false
    }
    
    func nextMonth(){
        if let date = Calendar.current.date(byAdding: .month, value: 1, to: month){
            month = date
            update()
        }
    }
    
    func prevMonth(){
        if let date = Calendar.current.date(byAdding: .month, value: -1, to: month){
            month = date
            update()
        }
    }
    
    func update() {
        if let transactions = DataManager.shared.loadTransactions(inMonth: self.month, context: context) {
            self.monthTransactions = transactions
        } else {
           self.monthTransactions = [nil]
        }
        self.monthName = Time.monthName.string(from: month)
    }
    
    func delete(index: Int) -> Bool {
        guard let toDelete = monthTransactions[index] else { return false }
        monthTransactions.remove(at: index)
        DataManager.shared.delete(toDelete, context: context)
        return true
    }
}
