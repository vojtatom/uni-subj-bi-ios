//
//  CheckinView.swift
//  BI-IOS
//
//  Created by Vojtěch Tomas on 23/12/2017.
//  Copyright © 2017 Vojtěch Tomas. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import FirebaseDatabase

class CheckinView : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    weak var mainView : UIView!
    weak var mainLabel : UILabel!
    weak var userLabel : UILabel!
    weak var genderLabel : UILabel!
    weak var userField : UITextField!
    weak var genderField : UIPickerView!
    
    var pickerData: [String] = [String]()
    var location : CLLocation!
    weak private var databaseReference: DatabaseReference!
    
    init(_ loc : CLLocation, _ database : DatabaseReference) {
        super.init(nibName: nil, bundle: nil);
        self.location = loc
        self.databaseReference = database
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        addMainView()
        //navigation buttons
        let buttons = addButtons()
        addMainLabel("Post my location!", under: buttons[0])
        let labelUser = addLocalLabel("User", under: self.mainLabel, size: 12, top: 20)
        addTextField(under: labelUser)
        let labelGender = addLocalLabel("Gender", under: self.userField, size: 12, top: 20)
        addPickerField(under: labelGender)
        let labelPosition = addLocalLabel("Position", under: self.genderField, size: 12, top: 20)
        let lat = addLocalLabel("lat: \(location.coordinate.latitude)", under: labelPosition, size: 15, top: 10)
        let lon = addLocalLabel("lon: \(location.coordinate.longitude)", under: lat, size: 15, top: 10)

        lon.snp.makeConstraints { make in
            make.bottom.equalTo(self.mainView).offset(-20)
        }
    }
    
    //add main view
    func addMainView(){
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.bottom.right.left.equalTo(0)
        }
        
        scrollView.backgroundColor = .white
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.topMargin)
            make.bottom.equalTo(0)
            make.width.equalTo(scrollView)
        }
        
        self.mainView = contentView
    }
    
    //add close and post buttons
    func addButtons() -> [UIButton]{
        let btnClose = UIButton(type: .system)
        let btnPost = UIButton(type: .system)
        self.mainView.addSubview(btnClose)
        self.mainView.addSubview(btnPost)
        btnClose.setTitle("Close", for: .normal)
        btnPost.setTitle("Post", for: .normal)
        
        btnClose.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.equalTo(10)
        }
        
        btnPost.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.right.equalTo(-10)
        }
        
        
        btnClose.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        btnPost.addTarget(self, action: #selector(postAndCloseView), for: .touchUpInside)
        
        return [btnClose, btnPost]
    }
    
    //action on close button
    @objc func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //action on post button
    @objc func postAndCloseView() {
        let loc = Location()
        loc.username = self.userField.text ?? ""
        loc.lat = self.location.coordinate.latitude
        loc.lon = self.location.coordinate.longitude
        loc.gender = self.pickerData[self.genderField.selectedRow(inComponent: 0)]
        loc.time = NSDate().timeIntervalSince1970
        
        let newLoc = databaseReference.childByAutoId()
        loc.key = newLoc.key
        newLoc.setValue(loc.serialize())
        
        print("posted user", loc.username ?? "unknown")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //add main label
    func addMainLabel(_ text : String, under parent: UIView) {
        let main = UILabel()
        self.mainView.addSubview(main)
        main.font = main.font.withSize(25)
        main.snp.makeConstraints { (make) in
            make.top.equalTo(parent.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        self.mainLabel = main
        main.text = text
    }
    
    //add local mabel
    func addLocalLabel(_ text : String, under parent : UIView, size : Int, top : Int ) -> UILabel {
        let label = UILabel()
        self.mainView.addSubview(label)
        label.font = label.font.withSize(CGFloat(size))
        label.snp.makeConstraints { (make) in
            make.top.equalTo(parent.snp.bottom).offset(top)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        label.text = text
        return label
    }
    
    //add textfield
    func addTextField(under parent : UIView) {
        let text = UITextField()
        self.mainView.addSubview(text)
        text.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(parent.snp.bottom).offset(10)
        }
        text.placeholder = "username"
        self.userField = text
    }
    
    //add gender picker
    func addPickerField(under parent : UIView) {
        let picker = UIPickerView()
        self.mainView.addSubview(picker)
        picker.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(parent.snp.bottom).offset(10)
            make.height.equalTo(100)
        }
        picker.dataSource = self
        picker.delegate = self
        //picker.backgroundColor = .gray
        self.genderField = picker
        
        pickerData = ["male", "female", "unknown"]
    }
    
    
    
//UIPickerViewDelegate, UIPickerViewDataSource stuff
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
}

