//
//  AddRepeatedView.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 08/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import UIKit
import SnapKit

enum FieldRepeated : String {
    case name
    case amount
    case from
    case to
    case monthly
    case period
}

enum SectionRepeated {
    case main
    case details
    
    var fields: [FieldRepeated] {
        switch self {
            case .main: return [.name, .amount]
            case .details: return [.from, .period, .monthly, .to]
        }
    }
    
    var title: String? {
        switch self {
        case .main: return "Main info"
        case .details: return "Details"
        }
    }
}

class RepeatedModifyViewController: UIViewController {
    private let sections: [SectionRepeated] = [.main, .details]
    private var expandedFrom: Bool = false
    private var expandedTo: Bool = false
    let delegate : FormDelegateRepeated
    let vm : RepeatedModifyViewModel
    weak var mainView : UIView!
    weak var segmented : UISegmentedControl!
    weak var tableView : UITableView!
    
    
    init(delegate: FormDelegateRepeated, viewModel: RepeatedModifyViewModel) {
        self.delegate = delegate
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil);
    }
    
    deinit {
        vm.remove()
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
        table.delegate = self
        table.dataSource = self
        table.register(FormCellText.self, forCellReuseIdentifier: "CellText")
        table.register(FormCellNumber.self, forCellReuseIdentifier: "CellNumber")
        table.register(FormCellDate.self, forCellReuseIdentifier: "CellDate")
        table.register(FormCellSwitch.self, forCellReuseIdentifier: "CellSwitch")
        self.tableView = table
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

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        vm.remove()
        delegate.dismissFormRepeated()
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
    
    @objc func remove() {
        vm.delete()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func handleTypeChaged(_ sender: UISegmentedControl) {
        vm.model.isExpense = (sender.selectedSegmentIndex == 0)
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension RepeatedModifyViewController : UITableViewDataSource {
    
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
                    cell.input.text = String(vm.model.amount)
                }
                cell.input.placeholder = vm.amountPlaceholder
                return cell
            case (.details, .from):
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellDate", for: indexPath) as! FormCellDate
                cell.title.text = field.rawValue
                cell.value.text = vm.from
                cell.input.tag = 1
                cell.input.addTarget(self, action: #selector(handleDatePicker(_:)), for: UIControlEvents.valueChanged)
                cell.input.date = vm.model.from ?? Date()
                //cell.inputField.minimumDate = Date()
                return cell
            case (.details, .to):
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellDate", for: indexPath) as! FormCellDate
                cell.title.text = field.rawValue
                cell.input.tag = 2
                cell.value.text = vm.to
                cell.input.addTarget(self, action: #selector(handleDatePicker(_:)), for: UIControlEvents.valueChanged)
                cell.input.date = vm.model.to ?? Date()
                //cell.inputField.minimumDate = Date()
                return cell
            case (.details, .monthly):
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellSwitch", for: indexPath) as! FormCellSwitch
                cell.title.text = field.rawValue
                cell.input.addTarget(self, action: #selector(handleSwitch(_:)), for: UIControlEvents.valueChanged)
                return cell
            case (.details, .period):
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellNumber", for: indexPath) as! FormCellNumber
                cell.title.text = field.rawValue
                cell.input.delegate = self
                cell.input.tag = 3
                if (vm.model.period != 0) {
                    cell.input.text = String(vm.model.period)
                }
                cell.input.placeholder = vm.periodPlaceholder
                return cell
            default:
                fatalError("unknown field")
        }
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        switch sender.tag {
            case 1:
                vm.model.from = sender.date
            case 2:
                vm.model.to = sender.date
        default:
            return
        }
    }
    
    @objc func handleSwitch(_ sender: UISwitch) {
        vm.model.monthly = sender.isOn
    }
}

extension RepeatedModifyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let field = section.fields[indexPath.row]
        
        switch (section, field) {
            case (.details, .from):
                self.expandedFrom = !self.expandedFrom
                tableView.beginUpdates()
                tableView.reloadRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                return
            case (.details, .to):
                self.expandedTo = !self.expandedTo
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
            case (.details, .from):
                return expandedFrom ? LayoutConst.callendarCell.rawValue : LayoutConst.infoCell.rawValue
            case (.details, .to):
                return expandedTo ? LayoutConst.callendarCell.rawValue : LayoutConst.infoCell.rawValue
            default:
                return LayoutConst.infoCell.rawValue
        }
    }
}

extension RepeatedModifyViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            vm.model.name = textField.text ?? Placeholders.none.rawValue
        case 2:
            vm.model.amount = Double(textField.text!) ?? 0.0
        case 3:
            vm.model.period = Int16(textField.text!) ?? 1
        default:
            return
        }
    }
}

