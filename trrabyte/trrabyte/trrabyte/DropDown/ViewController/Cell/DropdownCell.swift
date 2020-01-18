//
//  DropdownCell.swift
//  Puratos
//
//  Created by Diego Yael Luna Gasca on 11/13/19.
//  Copyright © 2019 Terrabyte. All rights reserved.
//

import Foundation
import UIKit

class DropdownCell: UICollectionViewCell {
    
    @IBOutlet weak var lb_title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupWithInfo(option: String) {
        lb_title.text = option
    }
    
}
