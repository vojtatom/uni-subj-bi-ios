//
//  HistoryViewController.swift
//  Pocket
//
//  Created by Vojtěch Tomas on 09/02/2018.
//  Copyright © 2018 Vojtěch Tomas. All rights reserved.
//

import Foundation
import UIKit

class TransactionViewController : UIViewController {
    weak var mainView : UIView!
    weak var tableView : UITableView!
    weak var month : UILabel!
    weak var back : UIButton!
    weak var front : UIButton!
    
    let vm : TransactionViewModel
    
    init(viewModel vm : TransactionViewModel) {
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
        
        /* CALENDAR NAVIGATION */
        let back = UIButton()
        view.addSubview(back)
        back.setImage(UIImage(named: "back"), for: .normal)
        back.titleLabel?.isHidden = true
        back.addTarget(self, action: #selector(prevMonth), for: .touchUpInside)
        self.back = back
        let left = UIBarButtonItem(customView: back)
        self.navigationItem.leftBarButtonItem = left
        
        let month = UILabel()
        view.addSubview(month)
        month.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        month.textAlignment = .center
        month.font = Theme.titleFont
        self.month = month
        navigationItem.titleView = month
        
        let front = UIButton()
        view.addSubview(front)
        front.setImage(UIImage(named: "next"), for: .normal)
        front.titleLabel?.isHidden = true
        front.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        self.front = front
        let right = UIBarButtonItem(customView: front)
        self.navigationItem.rightBarButtonItem = right
        
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
        self.tableView.register(TransactionCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.titleView?.sizeToFit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.update()
        self.month.text = vm.monthName
        tableView.reloadData()
    }
    
    @objc func nextMonth(){
        vm.nextMonth()
        self.month.text = vm.monthName
        tableView.reloadData()
        self.view.setNeedsDisplay()
    }
    
    @objc func prevMonth(){
        vm.prevMonth()
        self.month.text = vm.monthName
        tableView.reloadData()
        self.view.setNeedsDisplay()
    }
    
}


extension TransactionViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TransactionCell
        cell.name.text = vm.nameFor(index: indexPath.row)
        cell.amount.text = vm.amountFor(index: indexPath.row)
        cell.date.text = vm.dateFor(index: indexPath.row)
        cell.isExpense = vm.isExpenseFor(index: indexPath.row)
        
        if indexPath.row == vm.monthTransactions.count - 1 {
            cell.setLast()
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.monthTransactions.count
    }
}


extension TransactionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = self.vm.monthTransactions[indexPath.row] else { return }
        let viewModel = TransactionDetailViewModel(model: model, context: self.vm.context)
        let detail = TransactionDetailViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == vm.monthTransactions.count - 1 ? LayoutConst.transCell.rawValue + 10 : LayoutConst.transCell.rawValue
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // remove the item from the data model
        if vm.delete(index: indexPath.row) {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
