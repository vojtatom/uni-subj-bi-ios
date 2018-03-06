import Foundation
import Alamofire

class DataManager {
    func getRecipes( callback: @escaping (([RecipePrev]) -> ()))  {
        print("requesting data...")
        Alamofire.request("https://cookbook.ack.ee/api/v1/recipes").responseJSON { response in
            if let data = response.data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let recipes = try jsonDecoder.decode([RecipePrev].self, from: data)
                    callback(recipes)
                } catch {
                     print("Error info: \(error)")
                }
            }
        }
    }
    
    func getRecipe(id: String, callback: @escaping (RecipeFull) -> ()) {
        print("requesting data...")
        Alamofire.request("https://cookbook.ack.ee/api/v1/recipes/\(id)").responseJSON { response in
            if let data = response.data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let recipe = try jsonDecoder.decode(RecipeFull.self, from: data)
                    callback(recipe)
                } catch {
                    print("Error info: \(error)")
                }
            }
        }
    }
    
    func rateRecipe(id: String, score: Int?, callback: @escaping (Bool) -> ()) {
        
        var parameters : Parameters
        
        if let s = score {
            parameters = [ "score" : s ]
        } else {
            print("error value")
            callback(false)
            return
        }
        
        Alamofire.request("https://cookbook.ack.ee/api/v1/recipes/\(id)/ratings", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let data = response.data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let parsed = try jsonDecoder.decode(RatingConfirm.self, from: data)
                    print(parsed)
                    callback(true)
                } catch {
                    print("Error info: \(error)")
                    callback(false)
                }
            }
        }
    }
    
}


