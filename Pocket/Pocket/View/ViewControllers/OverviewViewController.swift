//
//  ViewController.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 08/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import UIKit
import SnapKit
import UserNotifications

enum FieldOverviewDetail : String {
    case history = "Previous Months"
    case current = "This Month"
    case total = "Total"
    case addTransaction = "Add Single Transaction"
    case addRepeated = "Add Repeated Transaction"
}

enum SectionOverviewDetail {
    case main
    case actions
    
    var fields: [FieldOverviewDetail] {
        switch self {
        case .main: return [.history, .current, .total]
        case .actions: return [.addTransaction, .addRepeated]
        }
    }
    
    var title: String? {
        switch self {
        case .main: return "Info"
        case .actions: return "Actions"
        }
    }
}

class OverviewViewController: UIViewController, FormDelegateRepeated, FormDelegateTransaction {
    
    private let sections: [SectionOverviewDetail] = [.main, .actions]
    weak var mainView: UIView!
    weak var tableView : UITableView!
    
    let vm = OverviewViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil);
        
        /* navigation settings */
        self.tabBarItem.title = "Overview"
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
        self.tableView.register(BalanceCell.self, forCellReuseIdentifier: "CellBalance")
        self.tableView.register(LinkCell.self, forCellReuseIdentifier: "CellLink")
    }
    
    func gradientView(start: UIColor, end: UIColor, parent: UIView, previous: UIView?) -> [UIView] {
        let main = GradientView()
        parent.addSubview(main)
        main.snp.makeConstraints { make in
            make.top.equalTo(previous?.snp.bottom ?? 0).offset(10)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.height.equalTo(80)
        }
        
        main.cornerRadius = 10
        main.startColor = Theme.minusS
        main.endColor = Theme.minusE
        
        let name = UILabel()
        main.addSubview(name)
        name.snp.makeConstraints { make in
            make.leading.equalTo(0).offset(10)
            make.top.equalTo(0).offset(10)
            make.width.equalTo(main.snp.width).multipliedBy(0.5)
        }
        name.textColor = .white
        
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
        
        return [name, amount, main]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNotificationSetupCheck()
        tabBarItem.title = "Overview"
        navigationItem.title = "Overview"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vm.update()
        tableView.reloadData()
    }
    
    @objc func addTransaction() {
        let transactionViewModel = TransactionModifyViewModel(context: nil, transaction: nil)
        let addTransaction = TransactionModifyViewController(delegate: self, viewModel: transactionViewModel)
        self.navigationController?.pushViewController(addTransaction, animated: true)
    }
    
    @objc func addRepeated() {
        let repeatedViewModel = RepeatedModifyViewModel(context: nil, repeated: nil)
        let addRepeated = RepeatedModifyViewController(delegate: self, viewModel: repeatedViewModel)
        self.navigationController?.pushViewController(addRepeated, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissFormRepeated() {
        vm.updateRepeated()
        vm.update()
        tableView.reloadData()
    }
    
    func dismissFormTransaction() {
        vm.update()
        tableView.reloadData()
    }
    
    func initNotificationSetupCheck() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
        { (success, error) in
            if success {
                print("Permission Granted")
            } else {
                print("There was a problem!")
            }
        }
    }
}

extension OverviewViewController : UITableViewDataSource {
    
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
        case (.main, .history):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellBalance", for: indexPath) as! BalanceCell
            cell.name.text = field.rawValue
            cell.amount.text = vm.previous
            cell.setColor(number: vm.sumBefore)
            return cell
        case (.main, .current):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellBalance", for: indexPath) as! BalanceCell
            cell.name.text = field.rawValue
            cell.amount.text = vm.current
            cell.setColor(number: vm.sumMonth)
            return cell
        case (.main, .total):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellBalance", for: indexPath) as! BalanceCell
            cell.name.text = field.rawValue
            cell.amount.text = vm.total
            cell.setColor(number: vm.sumTotal)
            cell.setLast()
            return cell
        case (.actions, .addTransaction):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellLink", for: indexPath) as! LinkCell
            cell.title.text = field.rawValue
            return cell
        case (.actions, .addRepeated):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellLink", for: indexPath) as! LinkCell
            cell.title.text = field.rawValue
            return cell
        default:
            fatalError("unknown field")
        }
    }
}

extension OverviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let field = section.fields[indexPath.row]
        
        switch (section, field) {
            case (.actions, .addTransaction):
                addTransaction()
            case (.actions, .addRepeated):
                addRepeated()
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        let field = section.fields[indexPath.row]
        
        switch (section) {
        case (.main):
            if field == .total {
                return LayoutConst.transCell.rawValue + 10
            } else {
                 return LayoutConst.transCell.rawValue
            }
        default:
            return LayoutConst.infoCell.rawValue
        }
    }
}

