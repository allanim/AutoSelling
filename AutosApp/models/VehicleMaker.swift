//
//  VehicleMaker.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-17.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class VehicleMaker: Object {
    
    enum Property: String {
        case id, maker
    }
    
    dynamic var id = UUID().uuidString
    dynamic var maker = ""
    
    override static func primaryKey() -> String? {
        return VehicleMaker.Property.id.rawValue
    }
    
    convenience init(_ maker: String) {
        self.init()
        self.maker = maker
    }
}

// CRUD methods
extension VehicleMaker {
    static func all(in realm: Realm = try! Realm()) -> Results<VehicleMaker> {
        return realm.objects(VehicleMaker.self)
            .sorted(byKeyPath: VehicleMaker.Property.maker.rawValue)
    }
    
    @discardableResult
    static func add(maker: String, in realm: Realm = try! Realm())
        -> VehicleMaker {
            let item = VehicleMaker(maker)
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
