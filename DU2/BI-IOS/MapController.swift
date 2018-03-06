//
//  MapController.swift
//  BI-IOS
//
//  Created by Vojtěch Tomas on 23/12/2017.
//  Copyright © 2017 Vojtěch Tomas. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import SnapKit
import FirebaseDatabase

class MapController : UIViewController, CLLocationManagerDelegate {
    
    weak var mapView: MapView!
    var locationManager: CLLocationManager!
    private var databaseReference: DatabaseReference!
    
    var myLocation : CLLocation?
    
    override func loadView() {
        super.loadView()
        
        //map view
        let mapView = MapView()
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.mapView = mapView
        
        //navigation buttons
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(loadCheckinView))
        self.navigationItem.rightBarButtonItems = [add]
        
    }
    
    @objc func loadCheckinView(){
        if let loc = myLocation {
            let checkinView = CheckinView(loc, databaseReference)
            self.present(checkinView, animated: true, completion: nil)
        } else {
            let message = "We don't have permission to use your location. Please change it in the settings."
            let alert = UIAlertController(title: "Privacy settings", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //database
        databaseReference = Database.database().reference().child("checkins")
        
        //observe database and react on addition
        databaseReference.observe(.childAdded) { [weak self] snapshot in
            
            //unpack
            guard let locDict = snapshot.value as? [String: Any] else {
                return
            }
            
            //deserialize new location and add to array
            if let l = Location.deserialize(from: locDict) {
                l.key = snapshot.key
                self?.mapView.addLocation(l)
            }
        }
        
        databaseReference.observe(.childRemoved) { [weak self] snapshot in
            self?.mapView.removeLocation(snapshot.key)
        }
        
        //location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    //work based on authorisation status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
            locationManager.startUpdatingLocation()
        }
    }
    
    //when location is changed
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = locations.last!
    }
    
}
