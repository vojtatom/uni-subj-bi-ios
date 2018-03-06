import Foundation
import UIKit

class DetailControler : UIViewController {
    
    weak var scrollView : UIScrollView!
    
    weak var descView : UILabel!
    weak var infoView : UILabel!
    weak var ingrView : UITableView!
    
    var color : UIColor!
    
    var dataManager = DataManager()
    var data : RecipeFull?
    var dataPrev : RecipePrev!
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, recipe rec : RecipePrev!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        self.dataPrev = rec
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView();
        view.backgroundColor = .white
        
        let hue = ((1 - min(Double(dataPrev.duration) / 30.0, 1.0)) * 150.0 + 15.0) / 360.0
        self.color = UIColor(hue: CGFloat(hue), saturation: 0.2, brightness: 1, alpha: 1)
        
        // Main views
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.bottom.right.left.equalTo(0)
        }
        self.scrollView = scrollView
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(0)
            make.width.equalTo(scrollView)
        }
        
        // Setup all subview
        let head = createHeader(parentView: contentView)
        let ingr = createTable(parentView: contentView, neigbourView: head, title: "Ingrediences")
        let desc = createText(parentView: contentView, neigbourView: ingr, title: "Description")
        let info = createText(parentView: contentView, neigbourView: desc, title: "Info")
        let rating = createRating(parentView: contentView, neigbourView: info, title: "Rating")
        
        rating.snp.makeConstraints { (make) in
            make.bottom.equalTo(-20)
        }
        
        self.ingrView = ingr
        self.descView = desc
        self.infoView = info
    }
    
// Networking stuff --------------------------------------------
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.dataManager.getRecipe( id: self.dataPrev.id, callback: { [weak self] recipes in
            self?.data = recipes
            self?.updateValues()
        })
    }
    
    func updateValues() {
        self.ingrView.reloadData()
        self.descView.text = self.data?.description.condensedWhitespace
        self.infoView.text = self.data?.info.condensedWhitespace
    }
    
    @objc func ratingTapped(_ sender: UIButton) {
        let score = sender.title(for: .normal)
        self.dataManager.rateRecipe(id: dataPrev.id, score: Int(score!), callback: { [weak self] result in
            var message : String
            if result == true {
                message = "Rating sent! 🎉 The changes in overall rating will show up after refresh."
            } else {
                message = "Rating failed..."
            }
            //let message = result ? "něco" : "něco jiného"
            let alert = UIAlertController(title: "Rating recipe", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true)
        })
    }
    
    
// Layouting stuff --------------------------------------------
    func createHeader(parentView pv : UIView) -> UILabel {
        let name = UILabel()
        pv.addSubview(name)
        name.font = name.font.withSize(20)
        name.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
        }
        
        let mainInfo = UILabel()
        pv.addSubview(mainInfo)
        mainInfo.font = mainInfo.font.withSize(15)
        mainInfo.textColor = .gray
        mainInfo.snp.makeConstraints { (make) in
            make.top.equalTo(name.snp.bottom).offset(5)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
        }
        
        name.text = dataPrev.name
        mainInfo.text = "\(dataPrev.duration) minutes - score \(String(format: "%.2f", dataPrev.score)) out of 5"
        
        return mainInfo;
    }
    
    func addSectionHeader(parentView pv : UIView, neigbourView nv : UIView, title t : String) -> UILabel  {
        let section = UILabel()
        pv.addSubview(section)
        section.font = section.font.withSize(15)
        section.snp.makeConstraints { (make) in
            make.top.equalTo(nv.snp.bottom).offset(10)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
        }
        section.text = t
        return section
    }
    
    func createText(parentView pv : UIView, neigbourView nv : UIView, title t : String) -> UILabel {
        let sectName = addSectionHeader(parentView: pv, neigbourView: nv, title: t)
        let sectText = UILabel()
        pv.addSubview(sectText)
        sectText.font = sectText.font.withSize(12)
        sectText.numberOfLines = 0
        sectText.lineBreakMode = NSLineBreakMode.byWordWrapping
        sectText.snp.makeConstraints { (make) in
            make.top.equalTo(sectName.snp.bottom).offset(10)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
        }
        sectText.text = "loading..."
        return sectText
    }
    
    func createTable(parentView pv : UIView, neigbourView nv : UIView, title t : String) -> UITableView {
        let sectName = addSectionHeader(parentView: pv, neigbourView: nv, title: t)
        
        let table = UITableView()
        table.backgroundColor = self.color
        table.dataSource = self
        table.register(IngredienceCell.self, forCellReuseIdentifier: "Cell")
        table.rowHeight = 44
        pv.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.top.equalTo(sectName.snp.bottom).offset(10)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(224)
        }
        
        return table
    }

    func addButton(parentView pv : UIView, prevButton pb : UIButton?, sectionTitle st: UIView, title t : String) -> UIButton {
        let button = UIButton()
        pv.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.equalTo(st.snp.bottom).offset(10)
            make.width.equalTo(pv).multipliedBy(0.2).offset(-4 / 5)
            make.height.equalTo(32)
            make.leading.equalTo( pb?.snp.trailing ?? 0 ).offset( pb != nil ? 1 : 0)
        }
        button.setTitle(t, for: .normal)
        var hue : Double
        if let i = Double(t){
            hue = ((i / 5.0) * 150.0 + 15.0) / 360.0
        } else {
            hue = 0
        }

        button.backgroundColor = UIColor(hue: CGFloat(hue), saturation: 0.5, brightness: 0.95, alpha: 1)
        //button.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.7, alpha: 1)
       
        return button
    }
    
    func createRating(parentView pv : UIView, neigbourView nv : UIView, title t : String) -> UIView {
        let st = addSectionHeader(parentView: pv, neigbourView: nv, title: t)
        let button1 = addButton(parentView: pv, prevButton: nil, sectionTitle: st, title: "1")
        button1.addTarget(self, action: #selector(ratingTapped(_:)), for: .touchUpInside)
        let button2 = addButton(parentView: pv, prevButton: button1, sectionTitle: st, title: "2")
        button2.addTarget(self, action: #selector(ratingTapped(_:)), for: .touchUpInside)
        let button3 = addButton(parentView: pv, prevButton: button2, sectionTitle: st, title: "3")
        button3.addTarget(self, action: #selector(ratingTapped(_:)), for: .touchUpInside)
        let button4 = addButton(parentView: pv, prevButton: button3, sectionTitle: st, title: "4")
        button4.addTarget(self, action: #selector(ratingTapped(_:)), for: .touchUpInside)
        let button5 = addButton(parentView: pv, prevButton: button4, sectionTitle: st, title: "5")
        button5.addTarget(self, action: #selector(ratingTapped(_:)), for: .touchUpInside)
        
        let sectText = UILabel()
        pv.addSubview(sectText)
        sectText.font = sectText.font.withSize(12)
        sectText.numberOfLines = 0
        sectText.lineBreakMode = NSLineBreakMode.byWordWrapping
        sectText.snp.makeConstraints { (make) in
            make.top.equalTo(button5.snp.bottom).offset(10)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
        }
        sectText.text = "If you wish, you can submit your own rating of the recipe. The rating will take affect after page refresh."
        
        return sectText
    }
    
}

//MARK: RecepiesListControler data source
extension DetailControler : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = self.data {
            return data.ingredients.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! IngredienceCell
        cell.accessoryType = UITableViewCellAccessoryType.none
        cell.backgroundColor = self.color
        if let data = self.data {
            cell.title = data.ingredients[indexPath.row]
        } else {
            cell.title = "loading..."
        }
        return cell
    }
    
    func configureCell(cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

extension String {
    var condensedWhitespace: String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}


