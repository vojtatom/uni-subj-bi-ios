//
//  BaseViewModel.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 12/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import Foundation

class BaseViewModel : NSObject {
    
    static var currency : String {
        get {
            return UserDefaults.standard.string(forKey: "Currency") ?? "$"
        }
    }
    
    static var initialBalance : Int {
        get {
            return UserDefaults.standard.integer(forKey: "Balance")
        }
    }
    
    override init() {
        super.init()
    }
}
