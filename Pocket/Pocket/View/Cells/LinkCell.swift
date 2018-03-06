//
//  LinkCell.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 12/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import Foundation
import UIKit

class LinkCell : UITableViewCell {
    weak var mainView : UIView!
    weak var title : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        
        let main = UIView()
        contentView.addSubview(main)
        main.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(10, 10, 10, 10))
        }
        self.mainView = main
        
        let title = UILabel()
        main.addSubview(title)
        title.snp.makeConstraints { make in
            make.leading.trailing.equalTo(0)
            make.top.equalTo(0)
        }
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
