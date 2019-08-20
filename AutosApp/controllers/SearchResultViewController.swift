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
    
    // result
    var result: [Vehicle] = []
    var selectedVehicleId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // get autos
        if (isSimepleSearch) {
            self.result = Vehicle.search(make: make!, model: model!).array()
        } else {
            self.result = Vehicle.search(make: make, model: model, vehicleStatus: vehicleStatus, vehicleType: vehicleType,
                                         minYear: minYear, maxPrice: maxPrice, transmission: transmission, color: color,
                                         maxKilometers: maxKilometers, fuelType: fuelType).array()
        }
        self.tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? UITabBarController, let index = self.sourceTabBarIndex {
            dest.selectedIndex = index
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
        //        performSegue(withIdentifier: "showDetail", sender: self)
        
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
