//
//  UINavigationController+Utils.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func setTerrabyteStyle() {
        changeNavigationBar(color: .clear)
        navigationBar.tintColor = .black
        navigationBar.backgroundColor = .clear
    }
    
    func isHideNavigationBar(_ hide: Bool) {
        self.setNavigationBarHidden(hide, animated: true)
    }
    
    func setTitleAttributes() {
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                          NSAttributedString.Key.font: UIFont().withSize(12)]
        navigationBar.titleTextAttributes = attributes
    }
    
    func changeNavigationBar(color: UIColor = .black) {
        setTitleAttributes()
        if color == UIColor.clear {
            navigationBar.isTranslucent = true
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        }
        navigationBar.barTintColor = color
        navigationBar.backgroundColor = .clear
    }
}
