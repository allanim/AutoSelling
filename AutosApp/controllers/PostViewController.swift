//
//  PostViewController.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-18.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import UIKit
import Firebase
import TransitionButton

class PostViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtStatus: UITextField!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtMake: UITextField!
    @IBOutlet weak var txtModel: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtDrive: UITextField!
    @IBOutlet weak var txtTransmission: UITextField!
    @IBOutlet weak var txtKilometers: UITextField!
    @IBOutlet weak var txtFuelType: UITextField!
    @IBOutlet weak var txtColor: UITextField!
    @IBOutlet weak var txtDoors: UITextField!
    @IBOutlet weak var txtSellerName: UITextField!
    @IBOutlet weak var txtSellerPhone: UITextField!
    @IBOutlet weak var txtSellerEmail: UITextField!
    
    var currentPicker: UIPickerView!
    var selectedPickerRow: Int?
    
    var years: [Int] = []
    var makers = VehicleMaker.all().array().compactMap { $0.maker }
    var models: [String] = []
    
    // autos
    let autosRef = Database.database().reference(withPath: "autos")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets years
        let calendar = Calendar.current
        let endYear = calendar.component(.year, from: Date())
        let startYear = endYear - 20
        for i in (startYear...endYear).reversed() {
            years.append(i)
        }
        
        // Set picker tag
        txtStatus.tag = 1
        txtType.tag = 2
        txtYear.tag = 3
        txtMake.tag = 4
        txtModel.tag = 5
        txtDrive.tag = 11
        txtTransmission.tag = 12
        txtFuelType.tag = 13
        txtColor.tag = 14
        txtDoors.tag = 15
        
        // set picker delegate
        txtStatus.delegate = self
        txtType.delegate = self
        txtYear.delegate = self
        txtMake.delegate = self
        txtModel.delegate = self
        txtDrive.delegate = self
        txtTransmission.delegate = self
        txtFuelType.delegate = self
        txtColor.delegate = self
        txtDoors.delegate = self
        
        // set user info
        let user = Auth.auth().currentUser
        let userInfoRef = Database.database().reference(withPath: "user-info")
        userInfoRef.child(user!.uid).observe(.value, with: { snapshot in
            let userInfo = UserInfo(snapshot: snapshot);
            self.txtSellerName.text = userInfo!.fullName
            self.txtSellerEmail.text = userInfo?.email
        })
        
    }
    
    // textFiled Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.tag == 5 && models.count == 0) {
            txtModel.resignFirstResponder()
            return
        }
        self.pickUpByEnum(textField: textField)
    }
    
    private func createPicker() -> UIPickerView {
        let picker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        picker.backgroundColor = .white
        picker.delegate = self
        return picker
    }
    
    // Pickup: Type
    private func pickUpByEnum(textField : UITextField) {
        
        // create picker
        let picker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        picker.backgroundColor = .white
        picker.delegate = self
        picker.tag = textField.tag
        
        // input picker
        textField.inputView = picker
        self.currentPicker = picker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.pickerDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    // Pickup:- Button Done of Picker
    @objc private func pickerDoneClick() {
        let selectedRow = currentPicker.selectedRow(inComponent: 0);
        switch currentPicker.tag {
        case 1:
            txtStatus.text = VehicleStatus.cases[selectedRow]
            txtStatus.resignFirstResponder()
        case 2:
            txtType.text = VehicleType.cases[selectedRow]
            txtType.resignFirstResponder()
        case 3:
            txtYear.text = String(years[selectedRow])
            txtYear.resignFirstResponder()
        case 4:
            txtMake.text = makers[selectedRow]
            txtModel.text = ""
            txtMake.resignFirstResponder()
            models = VehicleModel.models(maker: makers[selectedRow]).array().compactMap { $0.model }
        case 5:
            txtModel.text = models[selectedRow]
            txtModel.resignFirstResponder()
        case 11:
            txtDrive.text = Drive.cases[selectedRow]
            txtDrive.resignFirstResponder()
        case 12:
            txtTransmission.text = Transmission.cases[selectedRow]
            txtTransmission.resignFirstResponder()
        case 13:
            txtFuelType.text = FuelType.cases[selectedRow]
            txtFuelType.resignFirstResponder()
        case 14:
            txtColor.text = Colors.cases[selectedRow]
            txtColor.resignFirstResponder()
        case 15:
            txtDoors.text = Doors.cases[selectedRow]
            txtDoors.resignFirstResponder()
        default: break
        }
    }
    
    @IBAction func btnPostClick(_ sender: TransitionButton) {
        guard
            let type = txtType.text,
            let status = txtStatus.text,
            let maker = txtMake.text,
            let model = txtModel.text,
            let year = Int(txtYear.text ?? "0"),
            let price = Double(txtPrice.text ?? "0.0"),
            let name = txtSellerName.text,
            let phone = txtSellerPhone.text,
            let email = txtSellerEmail.text,
            type.count > 0,
            status.count > 0,
            maker.count > 0,
            model.count > 0,
            year > 0,
            price > 0,
            name.count > 0,
            phone.count > 0,
            email.count > 0
        else {
            return
        }
        
        
        // save user info
        let user = Auth.auth().currentUser
        var vehicle = Vehicle(uid: user!.uid, type: type,  status: status,
                              maker: maker, model: model, year: year, price: price,
                              phone: phone, email: email, name: name)
        vehicle.kilometers = Int(txtKilometers.text ?? "0")!
        if (txtDrive.text!.count > 0) {
            vehicle.drive = Drive.init(rawValue: txtDrive.text!)
        }
        if (txtTransmission.text!.count > 0) {
            vehicle.transmission = Transmission.init(rawValue: txtTransmission.text!)
        }
        if (txtColor.text!.count > 0) {
            vehicle.exteriorColor = Colors.init(rawValue: txtColor.text!)
        }
        if (txtFuelType.text!.count > 0) {
            vehicle.fuelType = FuelType.init(rawValue: txtFuelType.text!)
        }
        if (txtDoors.text!.count > 0) {
            vehicle.numberOfDoors = Doors.init(rawValue: txtDoors.text!)
        }
        
        // save
        let initAutos = self.autosRef.child(UUID.init().uuidString)
        initAutos.setValue(vehicle.toAnyObject())
        
        // move
//        self.performSegue(withIdentifier: self.postToList, sender: nil)
    }
}


extension PostViewController:  UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return VehicleStatus.size
        case 2:
            return VehicleType.size
        case 3:
            return years.count
        case 4:
            return makers.count
        case 5:
            return models.count
        case 11:
            return Drive.size
        case 12:
            return Transmission.size
        case 13:
            return FuelType.size
        case 14:
            return Colors.size
        case 15:
            return Doors.size
        default: break
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return VehicleStatus.cases[row]
        case 2:
            return VehicleType.cases[row]
        case 3:
            return String(years[row])
        case 4:
            return makers[row]
        case 5:
            return models[row]
        case 11:
            return Drive.cases[row]
        case 12:
            return Transmission.cases[row]
        case 13:
            return FuelType.cases[row]
        case 14:
            return Colors.cases[row]
        case 15:
            return Doors.cases[row]
        default: break
        }
        return ""
    }
}
