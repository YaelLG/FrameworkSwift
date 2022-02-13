//
//  DisclosureView.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import UIKit

@IBDesignable
open class DisclosureView: UIView {
    
    @IBInspectable var color: UIColor = .blue

    var isDrawable: Bool = true
    
    private var basicAnimation: CABasicAnimation
    private let bezierPath = UIBezierPath()
    private let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 0.5
        basicAnimation.isRemovedOnCompletion = false
        
        bezierPath.move(to: CGPoint(x: frame.width / 4, y: frame.height / 2.5))
        bezierPath.addLine(to: CGPoint(x: frame.width / 2, y: 3*frame.height / 5))
        bezierPath.addLine(to: CGPoint(x: 3 * frame.width / 4, y: frame.height / 2.5))
        
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard isDrawable else { return }
           
        isDrawable = false
        CATransaction.begin()
        CATransaction.setCompletionBlock {}
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        layer.addSublayer(shapeLayer)
        CATransaction.commit()
    }
}

