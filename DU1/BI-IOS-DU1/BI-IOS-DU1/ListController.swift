import Foundation
import UIKit

class ListController : UIViewController {
    
    weak var tableView : UITableView!
    var dataManager = DataManager()
    var data = [RecipePrev]()
    
    override func loadView() {
        super.loadView();
        
        navigationItem.title = "List of recipes"
        
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(RecipeCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(table)
        self.tableView = table
        
        table.snp.makeConstraints { (make) in
            make.size.equalTo(view)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.dataManager.getRecipes(callback: { [weak self] recipes in
            self?.data = recipes
            self?.tableView.reloadData()
        })
    }

}


//MARK: RecepiesListControler data source
extension ListController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecipeCell
        let hue = ((1 - min(Double(data[indexPath.row].duration) / 30.0, 1.0)) * 150.0 + 15.0) / 360.0

        let background = UIColor(hue: CGFloat(hue), saturation: 0.2, brightness: 1, alpha: 1)
        let text = UIColor(hue: CGFloat(hue), saturation: 0.5, brightness: 0.5, alpha: 1)
        
        cell.color = text
        cell.backgroundColor = background
        cell.recipe = data[indexPath.row]
        return cell
    }
    
    func configureCell(cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

//MARK: RecepiesListControler delegate
extension ListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detial = DetailControler(nibName: nil, bundle: nil, recipe: data[indexPath.row])
        self.navigationController?.pushViewController(detial, animated: true)
        return
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
