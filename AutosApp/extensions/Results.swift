//
//  Results.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-18.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import RealmSwift

extension Results {
    func array() -> [Element] {
        return (self.count > 0 ? self.map { $0 } : nil) ?? []
    }
}
