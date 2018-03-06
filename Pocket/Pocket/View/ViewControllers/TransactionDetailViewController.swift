//
//  TransactionDetailViewController.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 11/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import UIKit

enum FieldTransactionDetail : String {
    case master
    case name
    case amount
    case date
    case repeated
}

enum SectionTransactionDetail {
    case main
    case details
    
    var fields: [FieldTransactionDetail] {
        switch self {
        case .main: return [.master]
        case .details: return [.name, .amount, .date, .repeated]
        }
    }
    
    var title: String? {
        switch self {
        case .main: return "Main info"
        case .details: return "Details"
        }
    }
}

class TransactionDetailViewController: UIViewController, FormDelegateTransaction {
    private let sections: [SectionTransactionDetail] = [.main, .details]
    weak var mainView: UIView!
    weak var tableView : UITableView!
    let vm : TransactionDetailViewModel
    
    
    init(viewModel vm: TransactionDetailViewModel) {
        self.vm = vm
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
        self.tableView.register(TransactionCell.self, forCellReuseIdentifier: "CellTrans")
        self.tableView.register(InfoCell.self, forCellReuseIdentifier: "CellInfo")
        self.tableView.register(LinkCell.self, forCellReuseIdentifier: "CellLink")
     
        //navigation buttons
        let add = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(edit))
        self.navigationItem.rightBarButtonItems = [add]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func edit(){
        let viewModel = TransactionModifyViewModel(context: vm.context, transaction: vm.model)
        let modify = TransactionModifyViewController(delegate: self, viewModel: viewModel)
        self.navigationController?.pushViewController(modify, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissFormTransaction() {
        tableView.reloadData()
    }
}

extension TransactionDetailViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections[section] == .details && !vm.hasRepeated {
            return sections[section].fields.count - 1
        }
        return sections[section].fields.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let field = section.fields[indexPath.row]
        
        switch (section, field) {
        case (.main, .master):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellTrans", for: indexPath) as! TransactionCell
            cell.name.text = vm.name
            cell.amount.text = vm.amount
            cell.date.text = vm.date
            cell.isExpense = vm.model.isExpense
            cell.setLast()
            return cell
        case (.details, .name):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellInfo", for: indexPath) as! InfoCell
            cell.title.text = field.rawValue
            cell.value.text = vm.name
            return cell
        case (.details, .amount):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellInfo", for: indexPath) as! InfoCell
            cell.title.text = field.rawValue
            cell.value.text = vm.amount
            return cell
        case (.details, .date):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellInfo", for: indexPath) as! InfoCell
            cell.title.text = field.rawValue
            cell.value.text = vm.date
            return cell
        case (.details, .repeated):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellLink", for: indexPath) as! LinkCell
            cell.title.text = "Repeated transaction"
            return cell
        default:
            fatalError("unknown field")
        }
    }
}

extension TransactionDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let field = section.fields[indexPath.row]
        switch (section, field) {
            case (.details, .repeated):
                guard let model = vm.model.repeated else { return }
                let viewModel = RepeatedDetailViewModel(model: model, context: vm.context)
                let detial = RepeatedDetailViewController(viewModel: viewModel)
                self.navigationController?.pushViewController(detial, animated: true)
            default:
                return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        let field = section.fields[indexPath.row]
        
        switch (section, field) {
        case (.main, .master):
            return LayoutConst.transCell.rawValue + 10
        default:
            return LayoutConst.infoCell.rawValue
        }
    }
}
