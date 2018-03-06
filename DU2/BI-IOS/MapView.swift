//
//  MapView.swift
//  BI-IOS
//
//  Created by Vojtěch Tomas on 23/12/2017.
//  Copyright © 2017 Vojtěch Tomas. All rights reserved.
//

import Foundation
import MapKit

class MapView : MKMapView, MKMapViewDelegate {
    
    var locations : [Location] = []
    var dateFormatter : DateFormatter!
    let RI = "reuseIdentifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") // Beacuse why not
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        self.dateFormatter = dateFormatter
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLocation(_ loc : Location) {
        if locations.contains(where: { $0.key == loc.key }) {
            return
        }
        
        self.addAnnotation(loc)
        locations.append(loc)
        setNeedsDisplay()
        print("added annotation")
    }
    
    func removeLocation(_ key: String) {
        if let index = locations.index(where: { $0.key == key }) {
            self.removeAnnotation(self.locations[index])
            locations.remove(at: index)
            print("removed addotation")
            setNeedsDisplay()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: RI) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: RI)
        guard let loc = annotation as? Location else { return nil }
        let gender = loc.gender != "male" && loc.gender != "female" ? "unknown" : loc.gender!
        
        annotationView.image = UIImage(named: gender)
        annotationView.canShowCallout = true
        return annotationView
    }


}
