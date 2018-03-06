//
//  Location.swift
//  BI-IOS
//
//  Created by Vojtěch Tomas on 23/12/2017.
//  Copyright © 2017 Vojtěch Tomas. All rights reserved.
//

import Foundation
import MapKit

class Location : NSObject, MKAnnotation {
    
    var key: String?
    var time : Double!
    var lat : Double!
    var lon : Double!
    var username : String?
    var gender : String?
    
    var title : String? {
        return username ?? "unknown"
    }
    
    var subtitle : String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") // Beacuse why not
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = Date(timeIntervalSince1970: time)
        return dateFormatter.string(from: date)
    }
    
    var coordinate : CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    static func deserialize(from object: [String: Any]) -> Location? {
        let result = Location()

        //Check if everything is all right
        if let time = object["time"] as? Double,
            let lat = object["lat"] as? Double,
            let lon = object["lon"] as? Double {
            result.time = time
            result.lat = lat
            result.lon = lon
        } else {
            return nil
        }
        
        //Optionals
        result.username = object["username"] as? String
        result.gender = object["gender"] as? String
        return result
    }
    
    func serialize() -> [String: Any] {
        var result: [String: Any] = [:]
        
        result["time"] = time
        result["lat"] = lat
        result["lon"] = lon
        if username != "" {
            result["username"] = username
        }
        if gender != "unknown" {
            result["gender"] = gender
        }
        return result
    }
    
    
}
