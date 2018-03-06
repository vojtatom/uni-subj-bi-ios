//
//  AddTransactionView.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 08/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import UIKit
import SnapKit

enum FieldTransaction : String {
    case name
    case amount
    case date
}

enum SectionTransaction {
    case main
    
    var fields: [FieldTransaction] {
        switch self {
        case .main: return [.name, .amount, .date]
        }
    }
    
    var title: String? {
        switch self {
        case .main: return "Main info"
        }
    }
}

class TransactionModifyViewController: UIViewController {
    
    private let sections: [SectionTransaction] = [.main]

    let delegate : FormDelegateTransaction
    let vm: TransactionModifyViewModel
    weak var mainView : UIView!
    weak var segmented : UISegmentedControl!
    weak var tableView : UITableView!
    private var expanded: Bool = false
    
    init(delegate : FormDelegateTransaction, viewModel: TransactionModifyViewModel) {
        self.vm = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil);
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
        
        let segment = UISegmentedControl(items: ["Expense", "Income"])
        segment.sizeToFit()
        segment.tintColor = UIColor(red:0.99, green:0.00, blue:0.25, alpha:1.00)
        segment.selectedSegmentIndex = 0
        segment.selectedSegmentIndex = vm.model.isExpense ? 0 : 1
        segment.addTarget(self, action: #selector(handleTypeChaged(_:)), for: UIControlEvents.valueChanged)
        self.navigationItem.titleView = segment
        self.segmented = segment

        
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
        self.tableView.register(FormCellDate.self, forCellReuseIdentifier: "CellDate")
        self.hideKeyboardWhenTappedAround()
        
        //navigation buttons
        if self.vm.saved {
            let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(remove))
            self.navigationItem.rightBarButtonItems = [delete]
        } else {
            let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(accept))
            self.navigationItem.rightBarButtonItems = [add]
        }
    }
    
    @objc func accept() {
        let valid = vm.validate()
        if !vm.saved && !valid {
            let message = "Please fill all of the fields correctly."
            let alert = UIAlertController(title: "Not Valid", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        vm.remove()
        delegate.dismissFormTransaction()
    }
    
    @objc func remove() {
        vm.delete()
        navigationController?.popToRootViewController(animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTypeChaged(_ sender: UISegmentedControl) {
        vm.model.isExpense = (sender.selectedSegmentIndex == 0)
    }
}

extension TransactionModifyViewController : UITableViewDataSource {
    
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
        case (.main, .name):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellText", for: indexPath) as! FormCellText
            cell.title.text = field.rawValue
            cell.input.delegate = self
            cell.input.tag = 1
            cell.input.text = vm.model.name
            cell.input.placeholder = vm.namePlaceholder
            return cell
        case (.main, .amount):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellNumber", for: indexPath) as! FormCellNumber
            cell.title.text = field.rawValue
            cell.input.delegate = self
            cell.input.tag = 2
            if vm.model.amount != 0 {
                cell.input.text = vm.amount
            }
            cell.input.placeholder = vm.amountPlaceholder
            return cell
        case (.main, .date):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellDate", for: indexPath) as! FormCellDate
            cell.title.text = field.rawValue
            cell.value.text = vm.date
            cell.input.addTarget(self, action: #selector(handleDatePicker(_:)), for: UIControlEvents.valueChanged)
            cell.input.date = vm.model.date ?? Date()
            return cell
        }
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        vm.model.date = sender.date
    }
}

extension TransactionModifyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let field = section.fields[indexPath.row]
        
        switch (section, field) {
            case (.main, .date):
                self.expanded = !self.expanded
                tableView.beginUpdates()
                tableView.reloadRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                return
            default:
                return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        let field = section.fields[indexPath.row]
        
        switch (section, field) {
            case (.main, .date):
                return expanded ? LayoutConst.callendarCell.rawValue : LayoutConst.infoCell.rawValue
        default:
            return LayoutConst.infoCell.rawValue
        }
    }
}

extension TransactionModifyViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            vm.model.name = textField.text ?? Placeholders.none.rawValue
        case 2:
            vm.model.amount = Double(textField.text ?? "0") ?? 0.0
        default:
            return
        }
    }
}

