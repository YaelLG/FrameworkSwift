//
//  Optional+Utils.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation

public extension Optional where Wrapped: Any {
    
    var isNull: Bool {
        return self == nil || self is NSNull
    }
    
    func value(or defaultValue: Wrapped) -> Wrapped {
        if let wrappedItem = self {
            return wrappedItem
        }
        
        return defaultValue
    }
}
