//
//  Array+Utils.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
    
    func canBeUpdated(safe index: Index) -> Bool {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? true : false
    }
}
