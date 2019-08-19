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
    
    let uid: String
    
    var saleStatus: SaleStatus
    
    var type: VehicleType
    var status: VehicleStatus
    var maker: String
    var model: String
    var year: Int
    var price: Double
    var kilometers: Int
    
    var drive: Drive?
    var transmission: Transmission?
    var exteriorColor: Colors?
    var fuelType: FuelType?
    var numberOfDoors: Doors?
    
    var images: [String]?
    
    var phone: String
    var email: String
    var name: String
    
    var regDate: String
    
    init(uid: String, type: String, status: String, maker: String, model: String, year: Int, price: Double, phone: String, email: String, name: String) {
        self.ref = nil
        self.key = ""
        
        self.uid = uid
        self.saleStatus = SaleStatus.DRAFT
        self.type = VehicleType.init(rawValue: type)!
        self.status = VehicleStatus.init(rawValue: status)!
        self.maker = maker
        self.model = model
        self.year = year
        self.price = price
        self.kilometers = 0
        
        self.phone = phone
        self.email = email
        self.name = name
        
        let format = DateFormatter()
        format.dateFormat = "yyyyMMddHHmmss"
        self.regDate = format.string(from: Date())
        
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard
            let value = snapshot.value as? [String: AnyObject],
            let uid = value["uid"] as? String,
            let saleStatus = value["saleStatus"] as? String,
            let type = value["type"] as? String,
            let status = value["status"] as? String,
            let maker = value["maker"] as? String,
            let model = value["model"] as? String,
            let year = value["year"] as? Int,
            let price = value["price"] as? Double,
            let kilometers = value["kilometers"] as? Int,
            let drive = value["drive"] as? String,
            let transmission = value["transmission"] as? String,
            let exteriorColor = value["exteriorColor"] as? String,
            let fuelType = value["fuelType"] as? String,
            let numberOfDoors = value["numberOfDoors"] as? String,
            let phone = value["phone"] as? String,
            let email = value["email"] as? String,
            let name = value["name"] as? String,
            let regDate = value["regDate"] as? String
            else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.uid = uid
        self.saleStatus = SaleStatus.init(rawValue: saleStatus)!
        self.type = VehicleType.init(rawValue: type)!
        self.status = VehicleStatus.init(rawValue: status)!
        self.maker = maker
        self.model = model
        self.year = year
        self.price = price
        self.kilometers = kilometers
        self.drive = Drive.init(rawValue: drive)
        self.transmission = Transmission.init(rawValue: transmission)
        self.exteriorColor = Colors.init(rawValue: exteriorColor)
        self.fuelType = FuelType.init(rawValue: fuelType)
        self.numberOfDoors = Doors.init(rawValue: numberOfDoors)
        self.phone = phone
        self.email = email
        self.name = name
        self.regDate = regDate
        self.images = []
    }
    
    func toAnyObject() -> Any {
        return [
            "uid": uid,
            "saleStatus": saleStatus.rawValue,
            "type": type.rawValue,
            "status": status.rawValue,
            "maker": maker,
            "model": model,
            "year": year,
            "price": price,
            "kilometers": kilometers,
            "drive": drive?.rawValue ?? "",
            "transmission": transmission?.rawValue ?? "",
            "exteriorColor": exteriorColor?.rawValue ?? "",
            "fuelType": fuelType?.rawValue ?? "",
            "numberOfDoors": numberOfDoors?.rawValue ?? "",
            "phone": phone,
            "email": email,
            "name": name,
            "regDate": regDate
        ]
    }
}

enum SaleStatus: String, CaseIterable {
    case DRAFT = "Draft"
    case SALE = "Sale"
    case DONE = "Done"
    
    static var size: Int {
        return cases.count
    }
    
    static var cases: [String] {
        return SaleStatus.allCases.map { $0.rawValue }
    }
}

enum VehicleType: String, CaseIterable {
    case SEDAN = "Sedans"
    case SUV = "SUVs"
    case TRUCK = "Turcks"
    case VAN = "Vans"
    
    static var size: Int {
        return cases.count
    }
    
    static var cases: [String] {
        return VehicleType.allCases.map { $0.rawValue }
    }
}

enum VehicleStatus: String, CaseIterable {
    case NEW = "New"
    case USED = "Used"
    
    static var size: Int {
        return cases.count
    }
    
    static var cases: [String] {
        return VehicleStatus.allCases.map { $0.rawValue }
    }
}

enum Transmission: String, CaseIterable {
    case MANUAL = "Manual"
    case AUTOMATIC = "Automatic"
    
    static var size: Int {
        return cases.count
    }
    
    static var cases: [String] {
        return Transmission.allCases.map { $0.rawValue }
    }
}

enum Drive: String, CaseIterable {
    case FWD = "FWD"
    case RWD = "RWD"
    case AWD = "AWD"
    case x4 = "4x4"
    
    static var size: Int {
        return cases.count
    }
    
    static var cases: [String] {
        return Drive.allCases.map { $0.rawValue }
    }
}

enum FuelType: String, CaseIterable {
    case DIESEL = "Diesel"
    case GASOLINE = "Gasoline"
    case ELECTRIC = "Electric"
    case HYBRID = "Hybrid"
    case OTHER = "Other"
    
    static var size: Int {
        return cases.count
    }
    
    static var cases: [String] {
        return FuelType.allCases.map { $0.rawValue }
    }
}

enum Doors: String, CaseIterable {
    case D2 = "2 Doors"
    case D3 = "3 Doors"
    case D4 = "4 Doors"
    case D5 = "5 Doors"
    case Dx = "Other"
    
    static var size: Int {
        return cases.count
    }
    
    static var cases: [String] {
        return Doors.allCases.map { $0.rawValue }
    }
}

enum Colors: String, CaseIterable {
    case BLACK = "Black"
    case WHITE = "White"
    case GRAY = "Gray"
    case RED = "Red"
    case BLUE = "Blue"
    case GREEN = "Green"
    case YELLOW = "Yellow"
    case OTHER = "Other"
    
    static var size: Int {
        return cases.count
    }
    
    static var cases: [String] {
        return Colors.allCases.map { $0.rawValue }
    }
}
