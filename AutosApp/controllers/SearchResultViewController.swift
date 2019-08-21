//
//  SearchResultViewController.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-19.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // TabBarIndex
    var sourceTabBarIndex: Int?
    
    // Search condition
    var isSimepleSearch = true
    var make: String?
    var model: String?
    var vehicleStatus: VehicleStatus?
    var vehicleType: VehicleType?
    var minYear: Int?
    var maxPrice: Double?
    var transmission: Transmission?
    var color: Colors?
    var maxKilometers: Int?
    var fuelType: FuelType?
    var loadCache = false
    
    // result
    var result: [Vehicle] = []
    var selectedVehicleId: String?
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        // loading cache
        if (loadCache) {
            isSimepleSearch = userDefault.bool(forKey: "isSimepleSearch")
            make = userDefault.string(forKey: "make")
            model = userDefault.string(forKey: "model")
            if let value = userDefault.string(forKey: "vehicleStatus") {
                vehicleStatus = VehicleStatus.init(rawValue: value)
            }
            if let value = userDefault.string(forKey: "vehicleType") {
                vehicleType = VehicleType.init(rawValue: value)
            }
            minYear = userDefault.integer(forKey: "minYear")
            maxPrice = userDefault.double(forKey: "maxPrice")
            if let value = userDefault.string(forKey: "transmission") {
                transmission = Transmission.init(rawValue: value)
            }
            if let value = userDefault.string(forKey: "color") {
                color = Colors.init(rawValue: value)
            }
            maxKilometers = userDefault.integer(forKey: "maxKilometers")
            if let value = userDefault.string(forKey: "fuelType") {
                fuelType = FuelType.init(rawValue: value)
            }
        }
        
        
        // get autos
        if (isSimepleSearch) {
            self.result = Vehicle.search(make: make!, model: model!).array()
        } else {
            self.result = Vehicle.search(make: make, model: model, vehicleStatus: vehicleStatus, vehicleType: vehicleType,
                                         minYear: minYear, maxPrice: maxPrice, transmission: transmission, color: color,
                                         maxKilometers: maxKilometers, fuelType: fuelType).array()
        }
        self.tableView.reloadData()
        
        // save condition
        userDefault.set(isSimepleSearch, forKey: "isSimepleSearch")
        userDefault.set(make, forKey: "make")
        userDefault.set(model, forKey: "model")
        userDefault.set(vehicleStatus?.rawValue, forKey: "vehicleStatus")
        userDefault.set(vehicleType?.rawValue, forKey: "vehicleType")
        userDefault.set(minYear, forKey: "minYear")
        userDefault.set(maxPrice, forKey: "maxPrice")
        userDefault.set(transmission?.rawValue, forKey: "transmission")
        userDefault.set(color?.rawValue, forKey: "color")
        userDefault.set(maxKilometers, forKey: "maxKilometers")
        userDefault.set(fuelType?.rawValue, forKey: "fuelType")
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? UITabBarController, let index = self.sourceTabBarIndex {
            dest.selectedIndex = index
        } else if let dest = segue.destination as? AutoDetailsViewController {
            dest.sourceVehicleId = selectedVehicleId
            dest.backView = "SearchResult"
        }
    }
}


// Table View
extension SearchResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "autosItem", for: indexPath)
        let autosItem = result[indexPath.row]
        
        // set title & detail
        cell.textLabel?.text = autosItem.displayName
        cell.detailTextLabel?.text = autosItem.price.stringCurrencyPlural
        
        // set image
        if let resource = Bundle.main.path(forResource: autosItem.maker, ofType: "jpg")
            , let imgData = try? Data(contentsOf: URL(fileURLWithPath: resource)) {
            cell.imageView?.image = imageWithImage(UIImage(data: imgData)!)
        } else {
            cell.imageView?.image = imageWithImage(UIImage(named: "car")!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedVehicleId = result[indexPath.row].id
        performSegue(withIdentifier: "showDetail", sender: self)
        
    }
    
    private func imageWithImage(_ image: UIImage) -> UIImage{
        let newSize = CGSize(width: 40, height: 40)
        
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysOriginal)
    }
}
