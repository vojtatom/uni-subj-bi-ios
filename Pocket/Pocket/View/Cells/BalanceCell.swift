//
//  BalanceCell.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 12/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//


import Foundation
import UIKit

class BalanceCell : GradientCell {
    
    weak var name : UILabel!
    weak var amount : UILabel!
    weak var subtitle : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .none
        selectionStyle = .none
        
        let main = GradientView()
        contentView.addSubview(main)
        main.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(10, 10, 0, 10))
        }
        main.cornerRadius = 10
        self.mainView = main
        
        self.mainView.startColor = Theme.minusS
        self.mainView.endColor = Theme.minusE
        
        let name = UILabel()
        main.addSubview(name)
        name.snp.makeConstraints { make in
            make.leading.equalTo(0).offset(10)
            make.top.equalTo(0).offset(10)
            make.width.equalTo(main.snp.width).multipliedBy(0.5)
        }
        name.textColor = .white
        self.name = name
        
        let amount = UILabel()
        main.addSubview(amount)
        amount.snp.makeConstraints { make in
            make.leading.equalTo(name.snp.trailing).offset(10)
            make.trailing.equalTo(-10)
            make.top.equalTo(0).offset(8)
        }
        amount.font = Theme.amountFont
        amount.textAlignment = .right
        amount.textColor = .white
        self.amount = amount
        
        let subtitle = UILabel()
        main.addSubview(subtitle)
        subtitle.snp.makeConstraints { make in
            make.leading.equalTo(0).offset(10)
            make.top.equalTo(name.snp.bottom).offset(10)
            make.width.equalTo(main.snp.width).multipliedBy(0.3)
        }
        subtitle.font = Theme.smallFont
        subtitle.textColor = .white
        self.subtitle = subtitle
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColor(number : Double) {
        if number < 0 {
            self.mainView.startColor = Theme.minusS
            self.mainView.endColor = Theme.minusE
        } else {
            self.mainView.startColor = Theme.plusS
            self.mainView.endColor = Theme.plusE
        }
        
        self.mainView.setNeedsDisplay()
    }
}

