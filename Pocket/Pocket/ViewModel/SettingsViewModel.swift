//
//  SettingsViewModel.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 13/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewModel : BaseViewModel {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var balance : String {
        get {
            return String(BaseViewModel.initialBalance)
        }
    }
    
    override init() {
        super.init()
    }
    
    func writeSymbol(symbol : String) {
        UserDefaults.standard.set(symbol, forKey: "Currency")
    }
    
    func writeInitialBalance(amount : Int) {
        UserDefaults.standard.set(amount, forKey: "Balance")
    }
    
    func deleteAll() {
        DataManager.shared.deleteAll(entity: "Transaction", context: context)
        DataManager.shared.deleteAll(entity: "Repeated", context: context)
    }
    
    func deleteThisMonth() {
        DataManager.shared.deleteThisMonth(entity: "Transaction", context: context)
    }
    
}
