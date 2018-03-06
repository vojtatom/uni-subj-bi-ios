//
//  RepeatedViewController.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 11/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import UIKit
import SnapKit

class RepeatedViewController: UIViewController {
    
    weak var mainView : UIView!
    weak var tableView : UITableView!
    
    let vm : RepeatedViewModel
    
    init(viewModel vm : RepeatedViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil);
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
        self.tableView.register(RepeatedCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem.title = "Repeated"
        navigationItem.title = "Repeated"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.update()
        tableView.reloadData()
    }
    
}


extension RepeatedViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RepeatedCell
        cell.name.text = vm.nameFor(index: indexPath.row)
        cell.amount.text = vm.amountFor(index: indexPath.row)
        cell.date.text = vm.dateFromFor(index: indexPath.row)
        cell.to.text = vm.dateToFor(index: indexPath.row)
        cell.isExpense = vm.isExpenseFor(index: indexPath.row)
        
        if indexPath.row == vm.allRepeated.count - 1 {
            cell.setLast()
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.allRepeated.count
    }
}


extension RepeatedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* action after selection */
        guard let model = self.vm.allRepeated[indexPath.row] else { return }
        let viewModel = RepeatedDetailViewModel(model: model, context: self.vm.context)
        let detail = RepeatedDetailViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(detail, animated: true)
        return
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == vm.allRepeated.count - 1 ? LayoutConst.repetCell.rawValue + 10 : LayoutConst.repetCell.rawValue
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // remove the item from the data model
        if vm.delete(index: indexPath.row) {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}


