//
//  VehicleModels.swift
//  AutosApp
//
//  Created by Allan Im on 2019-07-24.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class VehicleModel: Object {
    
    enum Property: String {
        case id, maker, model
    }
    
    dynamic var id = UUID().uuidString
    dynamic var maker = ""
    dynamic var model = ""
    
    override static func primaryKey() -> String? {
        return VehicleModel.Property.id.rawValue
    }
    
    convenience init(_ maker: String, _ model: String) {
        self.init()
        self.maker = maker
        self.model = model
    }
}

// CRUD methods
extension VehicleModel {
    static func all(in realm: Realm = try! Realm()) -> Results<VehicleModel> {
        return realm.objects(VehicleModel.self)
            .sorted(byKeyPath: VehicleModel.Property.maker.rawValue)
            .sorted(byKeyPath: VehicleModel.Property.model.rawValue)
    }
    
    static func models(maker: String, in realm: Realm = try! Realm()) -> Results<VehicleModel> {
        let predicate = NSPredicate(format: "maker == %@", maker)
        return realm.objects(VehicleModel.self).filter(predicate)
            .sorted(byKeyPath: VehicleModel.Property.model.rawValue)
    }
    
    @discardableResult
    static func add(maker: String, model: String, in realm: Realm = try! Realm())
        -> VehicleModel {
            let item = VehicleModel(maker, model)
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
