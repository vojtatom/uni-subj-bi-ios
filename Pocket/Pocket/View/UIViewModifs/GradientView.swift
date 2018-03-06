//
//  GradientView.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 12/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {
    var startColor: UIColor = .blue {
        didSet {
            setNeedsLayout()
        }
    }
    
    var endColor: UIColor = .green {
        didSet {
            setNeedsLayout()
        }
    }
    
   var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var startPointY: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var endPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var endPointY: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        layer.cornerRadius = cornerRadius
    }
}
