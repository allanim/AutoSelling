//
//  SearchViewController.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-18.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var sgStatus: UISegmentedControl!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtMake: UITextField!
    @IBOutlet weak var txtModel: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtTransmission: UITextField!
    @IBOutlet weak var txtKilometers: UITextField!
    @IBOutlet weak var txtFuelType: UITextField!
    @IBOutlet weak var txtColor: UITextField!
    
    var currentPicker: UIPickerView!
    var selectedPickerRow: Int?
    
    var years: [Int] = []
    var makers = VehicleMaker.all().array().compactMap { $0.maker }
    var models: [String] = []
    
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
        txtType.tag = 2
        txtYear.tag = 3
        txtMake.tag = 4
        txtModel.tag = 5
        txtTransmission.tag = 12
        txtFuelType.tag = 13
        txtColor.tag = 14
        
        // set picker delegate
        txtType.delegate = self
        txtYear.delegate = self
        txtMake.delegate = self
        txtModel.delegate = self
        txtTransmission.delegate = self
        txtFuelType.delegate = self
        txtColor.delegate = self

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SearchResultViewController {
            dest.sourceTabBarIndex = self.tabBarController?.selectedIndex
            dest.isSimepleSearch = false
            
            if sgStatus.selectedSegmentIndex == 1 {
                dest.vehicleStatus = VehicleStatus.NEW
            } else if sgStatus.selectedSegmentIndex == 2 {
                dest.vehicleStatus = VehicleStatus.USED
            }
            if txtType.hasText {
                dest.vehicleType = VehicleType.init(rawValue: txtType.text!)
            }
            if txtYear.hasText {
                dest.minYear = Int(txtYear.text!)
            }
            if txtMake.hasText {
                dest.make = txtMake.text
            }
            if txtModel.hasText {
                dest.make = txtModel.text
            }
            if txtPrice.hasText {
                dest.maxPrice = Double(txtPrice.text!)
            }
            if txtTransmission.hasText {
                dest.transmission = Transmission.init(rawValue: txtTransmission.text!)
            }
            if txtKilometers.hasText {
                dest.maxKilometers = Int(txtKilometers.text!)
            }
            if txtFuelType.hasText {
                dest.fuelType = FuelType.init(rawValue: txtFuelType.text!)
            }
            if txtColor.hasText {
                dest.color = Colors.init(rawValue: txtColor.text!)
            }
            
        }
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
        case 12:
            txtTransmission.text = Transmission.cases[selectedRow]
            txtTransmission.resignFirstResponder()
        case 13:
            txtFuelType.text = FuelType.cases[selectedRow]
            txtFuelType.resignFirstResponder()
        case 14:
            txtColor.text = Colors.cases[selectedRow]
            txtColor.resignFirstResponder()
        default: break
        }
    }
    
    
    @IBAction func btnClearClick(_ sender: Any) {
        sgStatus.selectedSegmentIndex = 0
        txtType.text = ""
        txtYear.text = ""
        txtMake.text = ""
        txtModel.text = ""
        txtPrice.text = ""
        txtTransmission.text = ""
        txtKilometers.text = ""
        txtFuelType.text = ""
        txtColor.text = ""
    }
    
    @IBAction func btnSearchClick(_ sender: Any) {
        // move
        self.performSegue(withIdentifier: "SearchResult", sender: nil)
    }
}

extension SearchViewController:  UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 2:
            return VehicleType.size
        case 3:
            return years.count
        case 4:
            return makers.count
        case 5:
            return models.count
        case 12:
            return Transmission.size
        case 13:
            return FuelType.size
        case 14:
            return Colors.size
        default: break
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 2:
            return VehicleType.cases[row]
        case 3:
            return String(years[row])
        case 4:
            return makers[row]
        case 5:
            return models[row]
        case 12:
            return Transmission.cases[row]
        case 13:
            return FuelType.cases[row]
        case 14:
            return Colors.cases[row]
        default: break
        }
        return ""
    }
}
