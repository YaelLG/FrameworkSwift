//
//  AppDelegate.swift
//  Zygoo
//
//  Created by Diego Luna on 10/11/19.
//  Copyright © 2019 Terrabyte. All rights reserved.
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
    
    @objc class var zygooPurple: UIColor {
        return UIColor(red: 101.0 / 255.0, green: 14.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0)
    }
    
    @objc class var zygooYellow: UIColor {
        return UIColor(red: 249.0 / 255.0, green: 171.0 / 255.0, blue: 45.0 / 255.0, alpha: 1.0)
    }
    
    @objc class var zygooPurpleLight: UIColor {
        return UIColor(red: 145.0 / 255.0, green: 20.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
    }
    
    @objc class var zygooGreenLight: UIColor {
        return UIColor(red: 35.0 / 255.0, green: 196.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0)
    }
    
    @objc class var zygooGreenDark: UIColor {
        return UIColor(red: 5.0 / 255.0, green: 171.0 / 255.0, blue: 68.0 / 255.0, alpha: 1.0)
    }
    
    @objc class var zygooBlackText: UIColor {
        return UIColor(red: 66.0 / 255.0, green: 66.0 / 255.0, blue: 66.0 / 255.0, alpha: 1.0)
    }
    
    @objc class var zygooBlackTransparent: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.3)
    }
    
    @objc class var zygooBlueMan: UIColor {
        return UIColor(red: 61.0 / 255.0, green: 156.0 / 255.0, blue: 227.0 / 255.0, alpha: 0.3)
    }
    
    @objc class var zygooPinkWoman: UIColor {
        return UIColor(red: 211.0 / 255.0, green: 103.0 / 255.0, blue: 254.0 / 255.0, alpha: 0.3)
    }
    
    @objc class var zygooPink: UIColor {
        return UIColor(red: 251.0 / 255.0, green: 31.0 / 255.0, blue: 127.0 / 255.0, alpha: 1)
        
    }
}
