//
//  Double.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-19.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import Foundation

extension Double {

    var stringCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_CA")
        return formatter.string(from: NSNumber(value: self))!
    }
    var stringCurrencyPlural: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyPlural
        formatter.locale = Locale(identifier: "en_CA")
        return formatter.string(from: NSNumber(value: self))!
    }
}
