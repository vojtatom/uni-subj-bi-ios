struct RecipePrev : Codable {
    var name : String
    var duration : Int
    var id : String
    var score : Double
}

struct RecipeFull : Codable {
    var name : String
    var duration : Int
    var id : String
    var score : Double
    
    var ingredients = [String]()
    var description: String
    var info: String
}

struct RatingConfirm : Codable {
    var score : Int
    var recipe : String
    var id : String
}
