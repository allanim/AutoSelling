//
//  AutoDetailsViewController.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-20.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import UIKit

class AutoDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var naviBar: UINavigationBar!
    
    var backView: String?
    var sourceVehicleId: String!
    
    var data = [(title: String, detail: String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let auto = Vehicle.getAuto(id: sourceVehicleId) {
            data.append((title: "Vehicle Type", detail: auto.type))
            data.append((title: "Vehicle Status", detail: auto.status))
            data.append((title: "Make", detail: auto.maker))
            data.append((title: "Model", detail: auto.model))
            data.append((title: "Year", detail: String(auto.year)))
            data.append((title: "Price", detail: auto.price.stringCurrency))
            data.append((title: "Kilometers", detail: String(auto.kilometers)))
            
            data.append((title: "Drive", detail: String(auto.drive)))
            data.append((title: "Transmission", detail: String(auto.transmission)))
            data.append((title: "Exterior Color", detail: String(auto.exteriorColor)))
            data.append((title: "Fuel Type", detail: String(auto.fuelType)))
            data.append((title: "Number of doors", detail: String(auto.numberOfDoors)))
            
            self.naviBar.topItem?.title = "\(auto.maker) \(auto.model)"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SearchResultViewController {
            dest.loadCache = true
        }
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        if backView == "SearchResult" {
            performSegue(withIdentifier: "backResult", sender: self)
        } else {
            performSegue(withIdentifier: "backMyAutos", sender: self)
        }
    }
    

}

extension AutoDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fieldDetail", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].title
        cell.detailTextLabel?.text = data[indexPath.row].detail
        return cell
    }
    
}
