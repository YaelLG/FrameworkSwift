//
//  Dictionary+Extension.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation

extension Dictionary {
    func parseValue(key : String) -> String {
        if let obj = self as? JSON {
            let value = obj[key] as Any
            if value is String { return value as! String }
            else if value is NSNumber {
                let number : NSNumber = value as! NSNumber
                let stringNumber = number.stringValue
                return stringNumber
            } else if value is NSNull { return "" }
        }
        return ""
    }
}
