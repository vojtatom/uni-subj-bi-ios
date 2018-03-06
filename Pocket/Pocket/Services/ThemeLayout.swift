//
//  Layout.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 08/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import Foundation
import SnapKit
import UIKit


enum LayoutConst : CGFloat {
    case transCell = 80
    case repetCell = 100
    case callendarCell = 250
    case infoCell = 50
}


class Theme {
    static let plusS = UIColor(red:0.45, green:0.85, blue:0.75, alpha:1.0)
    static let plusE = UIColor(red:0.45, green:0.80, blue:0.70, alpha:1.0)
    static let minusS = UIColor(red:0.90, green:0.35, blue:0.25, alpha:1.0)
    static let minusE = UIColor(red:0.90, green:0.3, blue:0.2, alpha:1.0)
    
    static let titleFont = UIFont(name: "HelveticaNeue-Bold", size: 17)
    static let textFont = UIFont(name: "HelveticaNeue", size: 15)
    static let smallFont = UIFont(name: "HelveticaNeue", size: 12)
    static let amountFont = UIFont(name: "HelveticaNeue", size: 30)
}


extension UIButton {
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}


