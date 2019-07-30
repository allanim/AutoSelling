//
//  Vehicle.swift
//  AutosApp
//
//  Created by Allan Im on 2019-07-24.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import Foundation
import Firebase

struct Vehicle {
    let ref: DatabaseReference?
    let key: String
    
    var saleStatus: SaleStatus
    
    var type: VehicleType
    var status: VehicleStatus
    var maker: String
    var model: String
    var year: Int
    var price: Double
    var kilometers: Int
    
    var drive: Drive
    var transmission: Transmission
    var exteriorColor: String
    var fuelType: String
    var numberOfDoors: Doors
    
    var images: [String]
    
    var phone: String
    var email: String
    var name: String
    
    var countOfUnreadComments: Int
    
}

enum SaleStatus: String {
    case DRAFT = "Draft"
    case SALE = "Sale"
    case DONE = "Done"
}

enum VehicleType: String {
    case ANY = "Any"
    case SEDAN = "Sedans"
    case SUV = "SUVs"
    case TRUCK = "Turcks"
    case VAN = "Vans"
}

enum VehicleStatus: String {
    case ANY = "Any"
    case NEW = "New"
    case USED = "Used"
}

enum Transmission: String {
    case ANY = "Any"
    case MANUAL = "Manual"
    case AUTOMATIC = "Automatic"
}

enum Drive: String {
    case FWD = "FWD"
    case RWD = "RWD"
    case AWD = "AWD"
    case x4 = "4x4"
}

enum Doors: String {
    case D2 = "2 Doors"
    case D3 = "3 Doors"
    case D4 = "4 Doors"
    case D5 = "5 Doors"
    case Dx = "Other"
}
