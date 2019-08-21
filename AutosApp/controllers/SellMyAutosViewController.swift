//
//  SellMyAutosViewController.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-19.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import UIKit
import Firebase

class SellMyAutosViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // TabBarIndex
    var sourceTabBarIndex: Int?
    
    var myAutos: [Vehicle] = []
    var selectedVehicleId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // get autos
        let currentUser = Auth.auth().currentUser;
        self.myAutos = Vehicle.myAutos(uid: currentUser!.uid).array().compactMap { $0 }
        self.tableView.reloadData()
 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? UITabBarController, let index = self.sourceTabBarIndex {
            dest.selectedIndex = index
        } else if let dest = segue.destination as? AutoDetailsViewController {
            dest.sourceVehicleId = selectedVehicleId
            dest.backView = "SellMyAutos"
        }
    }
    
}

// Table View
extension SellMyAutosViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAutos.count
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
        let autosItem = myAutos[indexPath.row]
        
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
        self.selectedVehicleId = myAutos[indexPath.row].id
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
