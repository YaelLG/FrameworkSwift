//
//  UIDevice+Utils.swift
//  ZygooApp
//
//  Created by Diego Yael Luna Gasca on 12/5/19.
//  Copyright © 2019 Terrabyte. All rights reserved.
//

import Foundation
import AudioToolbox
import UIKit

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
