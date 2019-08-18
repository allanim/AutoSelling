//
//  HomeViewController.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-17.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import UIKit
import TransitionButton

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtMake: UITextField!
    @IBOutlet weak var txtModel: UITextField!
    
    var makePicker: UIPickerView!
    var selectedMake = 0
    var selectedModel = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtMake.delegate = self
        txtModel.isEnabled = false
    }
    
    @IBAction func btnSearchClick(_ sender: TransitionButton) {
    }
    
    //textFiled Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUpMake(self.txtMake)
    }
    
    // make:- Function of picker
    private func pickUpMake(_ textField : UITextField){
        
        self.makePicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.makePicker.backgroundColor = .white
        self.makePicker.delegate = self
        self.makePicker.selectRow(selectedMake, inComponent: 0, animated: true)
        self.makePicker.selectRow(selectedModel, inComponent: 1, animated: true)
        textField.inputView = self.makePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.pickerDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.pickerCancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    // mark:- Button Done of Picker
    @objc private func pickerDoneClick() {
        
        // Gets maker
        let makers = VehicleMaker.all().array().compactMap { $0.maker }
        let maker = makers[makePicker.selectedRow(inComponent: 0)]
        
        // Gets model
        let models: [String] = VehicleModel.models(maker: maker).array().compactMap { $0.model }

        // Sets data
        txtMake.text = maker
        txtModel.text = models[makePicker.selectedRow(inComponent: 1)]
        selectedMake = makePicker.selectedRow(inComponent: 0)
        selectedModel = makePicker.selectedRow(inComponent: 1)
        
        txtMake.resignFirstResponder()
        txtModel.resignFirstResponder()
        
    }
    
    // vehicle:- Button Cancel of Picker
    @objc func pickerCancelClick() {
        txtMake.resignFirstResponder()
        txtModel.resignFirstResponder()
    }
}

extension HomeViewController:  UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let makers = VehicleMaker.all().array().compactMap { $0.maker }
        
        var total = 0
        if component == 0 {
            total = makers.count
        } else {
            let maker = makers[makePicker.selectedRow(inComponent: 0)]
            total = VehicleModel.models(maker: maker).count
        }
        
        return total
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let makers = VehicleMaker.all().array().compactMap { $0.maker }
        
        var title = ""
        if component == 0 {
            title = makers[row]
        } else {
             let maker = makers[makePicker.selectedRow(inComponent: 0)]
            title = VehicleModel.models(maker: maker).array().compactMap { $0.model }[row]
        }
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.reloadComponent(1)
        }
    }
    
}
