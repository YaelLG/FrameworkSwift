//
//  UIColor+Extension.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    
    private typealias RGBAValues = (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)
    
    private class func getHexColor(from value: String) -> String {
        guard value.hasPrefix("#") else {
            return ""
        }
        
        let start = value.index(value.startIndex, offsetBy: 1)
        let hexColor = String(value[start...])
        
        return hexColor
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        let newRed = CGFloat(red) / 255
        let newGreen = CGFloat(green) / 255
        let newBlue = CGFloat(blue) / 255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
    }
    
    func getRandomColor() -> UIColor {
        let randomRed: CGFloat = CGFloat(drand48())
        let randomGreen: CGFloat = CGFloat(drand48())
        let randomBlue: CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    func image(at rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let context = UIGraphicsGetCurrentContext()
        setFill()
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
        
    func lighter(by proportion: CGFloat = 0.3) -> UIColor {
        return adjust(by: abs(proportion))
    }
        
    func darker(by proportion: CGFloat = 0.3) -> UIColor {
        return adjust(by: -1 * abs(proportion))
    }
        
    private func adjust(by proportion: CGFloat) -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
            
        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return self
        }
            
        return UIColor(red: min(red + proportion, 1.0),
                       green: min(green + proportion, 1.0),
                       blue: min(blue + proportion, 1.0),
                       alpha: alpha)
    }
}

public struct PrimaryColor {
    public let primary: UIColor = UIColor(red: 42, green: 107, blue: 200)
    public let disabledGrey = UIColor(red: 184, green: 196, blue: 203)
}

public struct SecondaryColor {
    public let titleContent: UIColor = UIColor(red: 18, green: 18, blue: 18)
    public let obscure: UIColor = UIColor(red: 51, green: 41, blue: 39)
    public let content: UIColor = UIColor(red: 112, green: 105, blue: 103)
    public let disable: UIColor = UIColor(red: 184, green: 180, blue: 180)
    public let divider: UIColor = UIColor(red: 184, green: 180, blue: 180, alpha: 0.4)
    public let contentDisable: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
}
