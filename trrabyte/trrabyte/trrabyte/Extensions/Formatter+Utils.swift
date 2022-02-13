//
//  Formatter+Utils.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation

public extension NumberFormatter {
    class func defaultFormatter(localeId: String = "MX") -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: localeId)
        return formatter
    }
    
    class func currencyFormatter(localeId: String = "MX",
                                 usesGroupingSeparator: Bool = true,
                                 showsFractionDigits: Bool = true) -> NumberFormatter {
        
        let formatter = defaultFormatter(localeId: localeId)
        formatter.usesGroupingSeparator = usesGroupingSeparator
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = showsFractionDigits ? 2 : 0
        
        // use the locale's currency symbol but also add a blank space so that the result is
        // "$ 10" instead of "$10".
        formatter.currencySymbol = "\(formatter.locale.currencySymbol ?? "")\u{00a0}"
        
        return formatter
    }
}

public extension Double {
    func string(using formatter: NumberFormatter) -> String {
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
