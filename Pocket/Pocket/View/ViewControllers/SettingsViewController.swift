//
//  RepeatedViewController.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 11/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import UIKit
import SnapKit

enum FieldSettings : String {
    case currency = "Currency"
    case base = "Initial balance"
    case deleteAll = "Delete All Data"
    case deleteMonth = "Delete This Month Data"
}

enum SectionSettings {
    case general
    case delete
    
    var fields: [FieldSettings] {
        switch self {
        case .general: return [.currency, .base]
        case .delete: return [.deleteAll, .deleteMonth]
        }
    }
    
    var title: String? {
        switch self {
        case .general: return "General"
        case .delete: return "Delete options"
        }
    }
}

class SettingsViewController: UIViewController {
    private let sections: [SectionSettings] = [.general, .delete]
    weak var mainView: UIView!
    weak var tableView: UITableView!
    
    let vm = SettingsViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil);
        
        /* navigation settings */
        tabBarItem.title = "Settings"
        navigationItem.title = "Settings"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        
        let main = UIView()
        view.addSubview(main)
        main.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.right.left.equalTo(0)
        }
        self.mainView = main
        
        /* TABLE */
        let table = UITableView()
        main.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.right.left.equalTo(0)
        }
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView = table
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(FormCellText.self, forCellReuseIdentifier: "CellText")
        self.tableView.register(FormCellNumber.self, forCellReuseIdentifier: "CellNumber")
        self.tableView.register(LinkCell.self, forCellReuseIdentifier: "CellAction")
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SettingsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].fields.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let field = section.fields[indexPath.row]
        
        switch (section, field) {
        case (.general, .currency):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellText", for: indexPath) as! FormCellText
            cell.title.text = field.rawValue
            cell.input.text = BaseViewModel.currency
            cell.input.delegate = self
            cell.input.tag = 1
            return cell
        case (.general, .base):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellNumber", for: indexPath) as! FormCellNumber
            cell.title.text = field.rawValue
            cell.input.text = vm.balance
            cell.input.delegate = self
            cell.input.tag = 2
            return cell
        case (.delete, .deleteAll):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellAction", for: indexPath) as! LinkCell
            cell.title.text = field.rawValue
            return cell
        case (.delete, .deleteMonth):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellAction", for: indexPath) as! LinkCell
            cell.title.text = field.rawValue
            return cell
        default:
            fatalError("unknown field")
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let field = section.fields[indexPath.row]
        /* to click */
        
        switch (section, field) {
        case (.delete, .deleteAll):
            let message = "Do you really wish to delete all?"
            let alert = UIAlertController(title: "Not Valid", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                self?.vm.deleteAll()
            }))
            self.present(alert, animated: true)
        case (.delete, .deleteMonth):
            let message = "Do you really wish to delete this month's records? (Repeated transactions will stay unaffected.)"
            let alert = UIAlertController(title: "Not Valid", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                self?.vm.deleteThisMonth()
            }))
            self.present(alert, animated: true)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LayoutConst.infoCell.rawValue
    }
}

extension SettingsViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch (textField.tag){
            case 1:
                guard let text = textField.text else { return }
                text == "" ? vm.writeSymbol(symbol: "$") : vm.writeSymbol(symbol: text)
            case 2:
                guard let text = textField.text else { return }
                guard let amount = Int(text) else { vm.writeInitialBalance(amount: 0); return }
                vm.writeInitialBalance(amount: amount)
            default:
                return
        }
    }
}

