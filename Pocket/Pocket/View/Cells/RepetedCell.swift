//
//  RepetedCell.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 12/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import Foundation
import UIKit

class RepeatedCell : TransactionCell {
    weak var to : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let date = UILabel()
        mainView.addSubview(date)
        date.snp.makeConstraints { make in
            make.leading.equalTo(0).offset(10)
            make.top.equalTo(self.date.snp.bottom).offset(4)
            make.width.equalTo(mainView.snp.width).multipliedBy(0.3)
        }
        date.font = Theme.smallFont
        date.textColor = .white
        self.to = date
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
