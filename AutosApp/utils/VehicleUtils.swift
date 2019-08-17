//
//  JsonUtils.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-17.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import Foundation

class VehicleUtils {
    
    // Save maker & model
    static func saveMakerAndModel() {
        
        if let jsonData: [[String: Any]] = getJsonObject(fileName: "car-list") {
            jsonData.forEach {
                let maker = $0["maker"] as! String
                let models = $0["models"] as! [String]
                
                VehicleMaker.add(maker: maker)
                for model in models {
                    VehicleModel.add(maker: maker, model: model)
                }
            }
        }
    }
    
    
    // Gets json data from resource
    static func getJsonObject<T>(fileName: String) -> T? {
        var result: T?
        if let resource = Bundle.main.path(forResource: fileName, ofType: "json") {
            if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: resource)) {
                if let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) {
                    result = json as? T
                }
            }
        } else {
            print("Do not exsit file")
        }
        return result
    }
    
}

