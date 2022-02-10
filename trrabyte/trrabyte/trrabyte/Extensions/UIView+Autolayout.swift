//
//  UIView+Autolayout.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation
import UIKit

public final class Associated<T>: NSObject, NSCopying {
    public typealias `Type` = T
    public let value: Type
    
    public init(_ value: Type) { self.value = value }
    
    public func copy(with zone: NSZone?) -> Any {
        return type(of: self).init(value)
    }
}

extension Associated where T: NSCopying {
    public func copyWithZone(_ zone: NSZone?) -> AnyObject {
        return type(of: self).init(value.copy(with: zone) as! Type)
    }
}

public extension UIView {
    
    func applyConstraintsToFillParentVW(_ view: UIView) {
        applyConstraintsToFillParentVW(view, verticalSpacing: 0, heightSpacing: 0)
    }
    
    func applyConstraintsToFillParentVW(_ view: UIView,
                                               verticalSpacing vertical: Float,
                                               heightSpacing height: Float) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let metrics = [
            "vSpacing": vertical,
            "hSpacing": height
        ]
        let views = ["view": view]
        
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-vSpacing-[view]-vSpacing-|",
                                                          options: .alignAllBottom,
                                                          metrics: metrics,
                                                          views: views)
        
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-hSpacing-[view]-hSpacing-|",
                                                          options: .alignAllBottom,
                                                          metrics: metrics,
                                                          views: views)
        addConstraints(vConstraints)
        addConstraints(hConstraints)
    }
    
    func applyAspectRatioVW(_ view: UIView) {
        
        translatesAutoresizingMaskIntoConstraints = false
        let views = ["view": view]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=0)-[view]-(>=0)-|",
                                                      options: .alignAllBottom,
                                                      metrics: nil,
                                                      views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=0)-[view]-(>=0)-|",
                                                      options: .alignAllBottom,
                                                      metrics: nil,
                                                      views: views))
        var c = NSLayoutConstraint(item: view,
                                   attribute: .width,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .width,
                                   multiplier: 1,
                                   constant: 0)
        
        let maxPriority: Float = 800
        c.priority = UILayoutPriority(maxPriority)
        addConstraint(c)
        
        c = NSLayoutConstraint(item: view,
                                   attribute: .height,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: .width,
                                   multiplier: 0.8,
                                   constant: 0)
        c.priority = UILayoutPriority(maxPriority)
        addConstraint(c)
        
        c = NSLayoutConstraint(item: view,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerY,
                               multiplier: 1,
                               constant: 0)
        
        let minPriority: Float = 1000
        c.priority = UILayoutPriority(minPriority)
        addConstraint(c)
        
        c = NSLayoutConstraint(item: view,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerX,
                               multiplier: 1,
                               constant: 0)
        c.priority = UILayoutPriority(minPriority)
        addConstraint(c)
    }
    
    func applyAspectRatio() {
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: self, attribute: .width,
                                            multiplier: frame.size.height / frame.size.width,
                                            constant: 0)
        
        addConstraint(constraint)
    }
    
    func centerOnSuperview() {
        guard let superview = superview else {
            return
        }
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
    }
    
    func fillParent() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
    }
    
    func setWidth(width: CGFloat, center: Bool) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: width).isActive = true
        if let superview = superview, center {
            centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
            centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        }
    }
    
    func topLeft(marginLeft: CGFloat, marginTop: CGFloat) {
        guard let superview = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        
        topAnchor.constraint(equalTo: superview.topAnchor, constant: marginTop).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: marginLeft).isActive = true
    }
    
    func adjustTop(marginLeft: CGFloat, marginRight: CGFloat, marginTop: CGFloat) {
        guard let superview = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superview.topAnchor, constant: marginTop).isActive = true
        if #available(iOS 11.0, *) {
            leftAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leftAnchor, constant: marginLeft).isActive = true
            rightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.rightAnchor, constant: -marginRight).isActive = true
        } else {
            leftAnchor.constraint(equalTo: superview.leftAnchor, constant: marginLeft).isActive = true
            rightAnchor.constraint(equalTo: superview.trailingAnchor, constant: -marginRight).isActive = true
        }
    }
    
    func addShadowBorder(radius: CGFloat, opacity: CGFloat, offsetX: CGFloat = 0, offsetY: CGFloat, cache: Bool = false, color: UIColor) {
        setupShadow(radius: radius, opacity: opacity, offsetX: offsetX, offsetY: offsetY, color: color, cache: cache)
    }
    
    func setupShadow(radius: CGFloat, opacity: CGFloat, offsetX: CGFloat = 0, offsetY: CGFloat, color: UIColor? = .black, cache: Bool = false) {
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        layer.shadowRadius = radius
        if let color = color {
            layer.shadowColor = color.cgColor
            clipsToBounds = false
        }
        layer.shadowOpacity = Float(opacity)
        if cache {
            createCachedShadow()
        }
    }
}
