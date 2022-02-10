//
//  UILabel+Utils.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func setWidthAccordingToFont(margin: CGFloat) {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: frame.height)
        guard let textLabel = text, let fontLabel = font  else { return }
        let boundingBox = textLabel.boundingRect(with: constraintRect,
                                                 options: .usesLineFragmentOrigin,
                                                 attributes: [NSAttributedString.Key.font: fontLabel],
                                                 context: nil)
        let widthScreen = UIScreen.main.bounds.width - 30
        frame = {
            var frame = self.frame
            frame.size.width = ceil(min(boundingBox.width, widthScreen)) + margin
            return frame
        }()
    }
    
    func getWidthAccordingToFont(margin: CGFloat, height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        guard let textLabel = text, let fontLabel = font  else { return 0 }
        let boundingBox = textLabel.boundingRect(with: constraintRect,
                                                 options: .usesLineFragmentOrigin,
                                                 attributes: [NSAttributedString.Key.font: fontLabel],
                                                 context: nil)
        let widthScreen = UIScreen.main.bounds.width - 30
        return ceil(min(boundingBox.width, widthScreen)) + margin
    }
    
    func setHeightAccordingToFont(margin: CGFloat) {
        let constraintRect = CGSize(width: frame.size.width, height: .greatestFiniteMagnitude)
        guard let textLabel = text, let fontLabel = font  else { return }
        let boundingBox = textLabel.boundingRect(with: constraintRect,
                                                 options: .usesLineFragmentOrigin,
                                                 attributes: [NSAttributedString.Key.font: fontLabel],
                                                 context: nil)
        
        frame = {
            var frame = self.frame
            frame.size.height = ceil(boundingBox.height) + margin
            return frame
        }()
    }
}
