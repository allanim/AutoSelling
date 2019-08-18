//
//  SearchViewController.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-18.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClearClick(_ sender: Any) {
    }
    
    @IBAction func btnSearchClick(_ sender: Any) {
    }
}
