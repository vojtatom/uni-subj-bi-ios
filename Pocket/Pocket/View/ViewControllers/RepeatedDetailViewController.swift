//
//  RepeatedDetailViewController.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 11/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import UIKit

enum FieldRepeatedDetail : String {
    case master
    case name
    case amount
    case from
    case to
    case period
}

enum SectionRepeatedDetail {
    case main
    case details
    
    var fields: [FieldRepeatedDetail] {
        switch self {
        case .main: return [.master]
        case .details: return [.name, .amount, .from, .to, .period]
        }
    }
    
    var title: String? {
        switch self {
        case .main: return "Main info"
        case .details: return "Details"
        }
    }
}

class RepeatedDetailViewController : UIViewController, FormDelegateRepeated {
    private let sections: [SectionRepeatedDetail] = [.main, .details]
    weak var mainView: UIView!
    weak var tableView : UITableView!
    let vm : RepeatedDetailViewModel
    
    init(viewModel vm: RepeatedDetailViewModel) {
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
        self.tableView.register(RepeatedCell.self, forCellReuseIdentifier: "CellRepe")
        self.tableView.register(InfoCell.self, forCellReuseIdentifier: "CellInfo")
        
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
        let viewModel = RepeatedModifyViewModel(context: vm.context, repeated: vm.model)
        let modify = RepeatedModifyViewController(delegate: self, viewModel: viewModel)
        self.navigationController?.pushViewController(modify, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissFormRepeated() {
        tableView.reloadData()
    }
    
}

extension RepeatedDetailViewController : UITableViewDataSource {
    
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
        case (.main, .master):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellRepe", for: indexPath) as! RepeatedCell
            cell.name.text = vm.model.name ?? Placeholders.none.rawValue
            cell.amount.text = vm.amount
            cell.date.text = vm.from
            cell.to.text = vm.to
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
        case (.details, .from):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellInfo", for: indexPath) as! InfoCell
            cell.title.text = field.rawValue
            cell.value.text = vm.from
            return cell
        case (.details, .to):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellInfo", for: indexPath) as! InfoCell
            cell.title.text = field.rawValue
            cell.value.text = vm.to
            return cell
        case (.details, .period):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellInfo", for: indexPath) as! InfoCell
            cell.title.text = field.rawValue
            cell.value.text = vm.period
            return cell
        default:
            fatalError("unknown field")
        }
    }
}

extension RepeatedDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* row selected */
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        let field = section.fields[indexPath.row]
        
        switch (section, field) {
        case (.main, .master):
            return LayoutConst.repetCell.rawValue + 10
        default:
            return LayoutConst.infoCell.rawValue
        }
    }
}
