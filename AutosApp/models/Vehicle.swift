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
    var priceMin: Double
    var priceMax: Double
    var transmission: Transmission
    var exteriorColor: String
    var kilometers: Int
    var fuelType: String
    
    var images: [String]
    
    var phoneNumber: String
    var email: String
    
    var countComment: Int
    
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
