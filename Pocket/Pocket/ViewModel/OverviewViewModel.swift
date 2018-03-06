//
//  OverviewViewModel.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 08/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class OverviewViewModel : BaseViewModel {
    
    var sumMonth : Double = 0.0
    var sumBefore : Double = 0.0
    var sumTotal : Double = Double(BaseViewModel.initialBalance)
    
    var previous : String {
        get {
            return String(sumBefore) + BaseViewModel.currency
        }
    }
    
    var current : String {
        get {
            return String(sumMonth) + BaseViewModel.currency
        }
    }
    
    var total : String {
        get {
            return String(sumTotal) + BaseViewModel.currency
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override init() {
        super.init()
        self.update()
        self.updateRepeated()
    }
    
    func update() {
        let today = Date()
        if let transactions = DataManager.shared.loadTransactions(inMonth: today, context: context) {
            sumMonth = sumTransactions(transactions: transactions)
        }

        if let transactions = DataManager.shared.loadTransactions(beforeMonth: today, context: context) {
            sumBefore = sumTransactions(transactions: transactions) + Double(BaseViewModel.initialBalance)
        }
        
        sumTotal = sumBefore + sumMonth
    }
    
    private func sumTransactions(transactions: [Transaction]) -> Double {
        var amount : Double = 0.0
        for transaction in transactions {
            amount += transaction.isExpense ? -transaction.amount : transaction.amount
        }
        return amount
    }
    
    func updateRepeated(){
        RepeatedManager.shared.update(context: context)
    }
}
