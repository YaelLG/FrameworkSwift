//
//  DropdownCell.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation
import UIKit

open class DropdownCell: UICollectionViewCell {
    
    @IBOutlet weak var lb_title: UILabel!
        
    func setupWithInfo(option: String) {
        lb_title.text = option
    }
    
}
