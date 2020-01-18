//
//  NSDictionary+Utils.swift
//  SearchBar
//
//  Created by Diego Yael on 1/29/19.
//  Copyright © 2019 Diego Yael. All rights reserved.
//

//
//  Dictionary+Utils.swift
//  Zygoo
//
//  Created by Diego Luna on 10/14/19.
//  Copyright © 2019 Terrabyte. All rights reserved.
//


import Foundation

extension Dictionary
{
    func parseValue(key : String) -> String
    {
        if let obj = self as? JSON
        {
            let value = obj[key] as Any
            if value is String
            {
                return value as! String
            }
            else if value is NSNumber
            {
                let number : NSNumber = value as! NSNumber
                let stringNumber = number.stringValue
                return stringNumber
            }else if value is NSNull
            {
                return ""
            }
        }
        
        return ""
    }
}
