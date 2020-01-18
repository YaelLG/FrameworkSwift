//
//  BasicInfo.swift
//
//  Created by Diego Yael on 2/13/19.
//  Copyright © 2019 Diego Yael. All rights reserved.
//

import Foundation

let kBasicInfoTitulo = "kBasicInfoTitulo"
let kBasicInfoDescripcion = "kBasicInfoDescripcion"
let kBasicInfoImgNombre = "kBasicInfoImgNombre"

class BasicInfo: NSObject
{
    var basicInfoTitulo : String
    var basicInfoDesc : String!
    var basicInfoImgName : String!

    init(dictionary : Dictionary<String, Any>)
    {
        self.basicInfoTitulo = dictionary.parseValue(key: kBasicInfoTitulo)
        self.basicInfoDesc = dictionary.parseValue(key: kBasicInfoDescripcion)
        self.basicInfoImgName = dictionary.parseValue(key: kBasicInfoImgNombre)
    }
    
    
    
}
