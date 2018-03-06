//
//  InfoCell.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 12/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import Foundation
import UIKit

class InfoCell : UITableViewCell {
    weak var mainView : UIView!
    weak var title : UILabel!
    weak var value : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .none
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
            make.leading.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(main.snp.width).multipliedBy(0.3)
        }
        self.title = title
        
        let label = UILabel()
        main.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(title.snp.trailing)
            make.trailing.equalTo(0)
        }
        label.textAlignment = NSTextAlignment.right
        self.value = label
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
