import Foundation
import UIKit
import SnapKit

class RecipeCell : UITableViewCell {
    
    weak var recipeName : UILabel!
    weak var recipeTime : UILabel!
    weak var recipeRating : UILabel!
    var id : String!
    var recipe : RecipePrev? {
        didSet {
            if let recipe = recipe {
                self.recipeTime.text = "\(recipe.duration) minutes"
                self.recipeName.text = recipe.name
                self.id = recipe.id
            }
        }
    }
    
    var color : UIColor? {
        didSet {
            if let color = color {
                self.recipeTime.textColor = color
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        
        let view = UIView()
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.top.equalTo(10)
            make.trailing.equalTo(-10)
            //make.centerY.equalTo(contentView)
        }
        
        let name = UILabel()
        view.addSubview(name)
        name.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view)
        }
        self.recipeName = name
        
        let time = UILabel()
        view.addSubview(time)
        time.font = time.font.withSize(15)
        time.textColor = .gray
        time.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(name.snp.bottom).offset(10)
        }
        self.recipeTime = time
        
    }
}

class IngredienceCell : UITableViewCell {
    
    weak var item : UILabel!
    var title : String? {
        didSet {
            if let title = title {
                self.item.text = title
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        
        let item = UILabel()
        contentView.addSubview(item)
        item.font = item.font.withSize(12)
        item.numberOfLines = 0
        item.lineBreakMode = NSLineBreakMode.byWordWrapping
        item.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.centerY.equalTo(contentView)
        }
        self.item = item
        
    }
}
