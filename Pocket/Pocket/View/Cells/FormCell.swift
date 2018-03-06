//
//  FormCell.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 11/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import Foundation
import UIKit

class FormCell : UITableViewCell {
    weak var mainView : UIView!
    weak var title : UILabel!
    
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
        
        let label = UILabel()
        main.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(main.snp.width).multipliedBy(0.5)
        }
        self.title = label
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: TEXT
class FormCellText : FormCell {
    weak var input : UITextField!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let input = UITextField()
        mainView.addSubview(input)
        input.snp.makeConstraints { make in
            make.top.trailing.equalTo(0)
            make.leading.equalTo(self.title.snp.trailing)
        }
        input.textAlignment = .right
        self.input = input
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: NUMBERS
class FormCellNumber : FormCell {

    weak var input : UITextField!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let input = UITextField()
        mainView.addSubview(input)
        input.snp.makeConstraints { make in
            make.top.trailing.equalTo(0)
            make.leading.equalTo(self.title.snp.trailing)
        }
        input.textAlignment = .right
        input.keyboardType = .decimalPad
        self.input = input
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: DATE
class FormCellDate : FormCell {
    
    weak var input : UIDatePicker!
    weak var value : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let label = UILabel()
        mainView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(title.snp.trailing)
            make.trailing.equalTo(0)
        }
        label.textAlignment = NSTextAlignment.right
        self.value = label
        
        let input = UIDatePicker()
        mainView.addSubview(input)
        input.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.leading.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }
        input.datePickerMode = UIDatePickerMode.date
        self.input = input
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: SWITCH
class FormCellSwitch : FormCell {
    
    weak var input : UISwitch!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let controlSwitch = UISwitch()
        mainView.addSubview(controlSwitch)
        controlSwitch.snp.makeConstraints { make in
            make.top.trailing.equalTo(0)
        }
        self.input = controlSwitch
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

