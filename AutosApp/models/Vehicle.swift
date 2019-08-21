//
//  Vehicle.swift
//  AutosApp
//
//  Created by Allan Im on 2019-07-24.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Vehicle: Object  {
    
    enum Property: String {
        case id, uid, regDate
    }
    
    dynamic var id = UUID().uuidString
    
    dynamic var uid = ""
    dynamic var saleStatus = ""
    
    dynamic var type = ""
    dynamic var status = ""
    dynamic var maker = ""
    dynamic var model = ""
    dynamic var year = 2019
    dynamic var price = 0.0
    dynamic var kilometers = 0
    
    dynamic var drive = ""
    dynamic var transmission = ""
    dynamic var exteriorColor = ""
    dynamic var fuelType = ""
    dynamic var numberOfDoors = ""
    
    dynamic var phone = ""
    dynamic var email = ""
    dynamic var name = ""
    
    dynamic var regDate = ""
    
    var displayName: String {
        get {
            return String(year) + " " + maker + " " + model
        }
    }
    
    override static func primaryKey() -> String? {
        return Vehicle.Property.id.rawValue
    }
    
    convenience init(uid: String,
                     type: String, status: String, maker: String, model: String, year: Int, price: Double,
                     kilometers: Int, drive: String, transmission: String, color: String, fuelType: String, doors: String,
                     phone: String, email: String, name: String) {
        
        self.init()
        
        self.uid = uid
        self.saleStatus = saleStatus
        
        self.type = type
        self.status = status
        self.maker = maker
        self.model = model
        self.year = year
        self.price = price
        
        self.kilometers = kilometers
        self.drive = drive
        self.transmission = transmission
        self.exteriorColor = color
        self.fuelType = fuelType
        self.numberOfDoors = doors
        
        self.phone = phone
        self.email = email
        self.name = name
        
        let format = DateFormatter()
        format.dateFormat = "yyyyMMddHHmmss"
        self.regDate = format.string(from: Date())
        
    }
}

// CRUD methods
extension Vehicle {
    static func all(in realm: Realm = try! Realm()) -> Results<Vehicle> {
        return realm.objects(Vehicle.self)
            .sorted(byKeyPath: Vehicle.Property.regDate.rawValue, ascending: false)
    }
    
    static func myAutos(uid: String, in realm: Realm = try! Realm()) -> Results<Vehicle> {
        let predicate = NSPredicate(format: "uid == %@", uid)
        return realm.objects(Vehicle.self)
            .filter(predicate)
            .sorted(byKeyPath: Vehicle.Property.regDate.rawValue, ascending: false)
    }
    
    static func getAuto(id: String, in realm: Realm = try! Realm()) -> Vehicle? {
        return realm.object(ofType: Vehicle.self, forPrimaryKey: id)
    }
    
    static func search(make: String, model: String, in realm: Realm = try! Realm()) -> Results<Vehicle> {
        if make == "" {
            return realm.objects(Vehicle.self)
                .sorted(byKeyPath: Vehicle.Property.regDate.rawValue, ascending: false)
        } else {
            let predicate = NSPredicate(format: "maker == %@ and model == %@", make, model)
            return realm.objects(Vehicle.self)
                .filter(predicate)
                .sorted(byKeyPath: Vehicle.Property.regDate.rawValue, ascending: false)
        }
    }
    
    static func search(make: String?, model: String?,
                       vehicleStatus: VehicleStatus?, vehicleType: VehicleType?, minYear: Int?, maxPrice: Double?,
                       transmission: Transmission?, color: Colors?, maxKilometers: Int?, fuelType: FuelType?,
                       in realm: Realm = try! Realm()) -> Results<Vehicle> {
        var condition = ""
        
        if make != nil {
            condition = query(org: condition, add: " maker == '\(make!)'")
        }
        if model != nil {
            condition = query(org: condition, add: " model == '\(model!)'")
        }
        if vehicleStatus != nil {
            condition = query(org: condition, add: " status == '\(vehicleStatus!.rawValue)'")
        }
        if vehicleType != nil {
            condition = query(org: condition, add: " type == '\(vehicleType!.rawValue)'")
        }
        if minYear != nil {
            condition = query(org: condition, add: " year >= \(minYear!)")
        }
        if maxPrice != nil {
            condition = query(org: condition, add: " price <= \(maxPrice!)")
        }
        if transmission != nil {
            condition = query(org: condition, add: " transmission == '\(transmission!.rawValue)'")
        }
        if color != nil {
            condition = query(org: condition, add: " exteriorColor == '\(color!.rawValue)'")
        }
        if maxKilometers != nil {
            condition = query(org: condition, add: " kilometers <= \(maxKilometers!)")
        }
        if fuelType != nil {
            condition = query(org: condition, add: " fuelType == '\(fuelType!.rawValue)'")
        }
        
        if condition.count == 0 {
            return realm.objects(Vehicle.self)
                .sorted(byKeyPath: Vehicle.Property.regDate.rawValue, ascending: false)
        } else {
            return realm.objects(Vehicle.self)
                .filter(condition)
                .sorted(byKeyPath: Vehicle.Property.regDate.rawValue, ascending: false)
        }

    }
    
    static func query(org: String, add: String) -> String {
        var query = org
        if query.count > 0 {
            query = query + " and"
        }
        return query + " " + add
    }
    
    @discardableResult
    static func add(uid: String,
                    type: String, status: String, maker: String, model: String, year: Int, price: Double,
                    kilometers: Int, drive: String, transmission: String, color: String, fuelType: String, doors: String,
                    phone: String, email: String, name: String,
                    in realm: Realm = try! Realm())
        -> Vehicle {
            let item = Vehicle(uid: uid,
                               type: type, status: status, maker: maker, model: model, year: year, price: price,
                               kilometers: kilometers, drive: drive, transmission: transmission, color: color, fuelType: fuelType, doors: doors,
                               phone: phone, email: email, name: name)
            try! realm.write {
                realm.add(item)
            }
            return item
    }
    
    func delete() {
        guard let realm = realm else { return }
        try! realm.write {
            realm.delete(self)
        }
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
