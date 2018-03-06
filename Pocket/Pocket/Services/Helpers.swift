//
//  Helpers.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 11/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import Foundation
import UIKit

enum Placeholders : String{
    case none = "-"
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

enum Time {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("dd MM yyyy")
        return formatter
    }()
    static let monthName: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("LLL yyyy")
        return formatter
    }()
    static let lastMonthName: String = {
        if let date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) {
            return Time.monthName.string(from: date)
        }
        return Placeholders.none.rawValue
    }()
    static let thisMonthName: String = {
        return Time.monthName.string(from: Date())
    }()
    static let calendar: Calendar = {
        return Calendar(identifier: .gregorian)
    }()
}

protocol FormDelegateRepeated {
    func dismissFormRepeated()
}

protocol FormDelegateTransaction {
    func dismissFormTransaction()
}
