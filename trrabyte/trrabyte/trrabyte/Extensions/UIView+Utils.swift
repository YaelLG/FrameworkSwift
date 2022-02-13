//
//  UIView+Extension.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
        
    static func initFromNib<T: UIView>(className: AnyClass) -> T {
        let frameworkBundle = Bundle(for: className)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("trrabyte.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        guard let view = resourceBundle?.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as? T else {
            return T()
        }
        return view
    }
    
    @objc func gradient(colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = frame.size
        gradientLayer.colors = colors.map { $0.cgColor }
        var locations = [CGFloat]()
        for i in 0 ..< colors.count {
            locations.append(CGFloat(i) / CGFloat(colors.count-1))
        }
        gradientLayer.locations = locations as [NSNumber]
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func setup(constraints: String, to views: [String : UIView], options: NSLayoutConstraint.FormatOptions = [], with metrics: [String : Any]? = nil) {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: constraints, options: options, metrics: metrics, views: views))
    }
    
    func addConstraintsToFit(view: UIView) {
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                 options: NSLayoutConstraint.FormatOptions(),
                                                                 metrics: nil,
                                                                 views: ["view": view])
        addConstraints(verticalConstraints)
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                   options: NSLayoutConstraint.FormatOptions(),
                                                                   metrics: nil,
                                                                   views: ["view": view])
        addConstraints(horizontalConstraints)
    }
    
    func centerHorizontally(toItem view: UIView, offset: Float = 0) {
        let centerConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: CGFloat(offset))
        NSLayoutConstraint.activate([centerConstraint])
    }
    
    func centerVertically(toItem view: UIView, offset: Float = 0) {
        let constraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: CGFloat(offset))
        NSLayoutConstraint.activate([constraint])
    }
    
    func addConstraintFixedWidth(_ width: Float) {
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(width))
        NSLayoutConstraint.activate([constraint])
    }
    
    func addConstraintFixedHeight(_ height: Float) {
        let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(height))
        NSLayoutConstraint.activate([constraint])
    }
    
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraintsToFit(view: self)
    }
    
    func setup(roundedCorners: RoundedCorners) {
        setupRoundedCorners(radius: roundedCorners.radius, corners: roundedCorners.corners)
    }
    
    func setupRoundedCorners(radius: CGFloat, corners: UIRectCorner = .allCorners) {
        layer.cornerRadius = radius
        clipsToBounds = true
        if let mask = corners.mask {
            layer.maskedCorners = mask
        }
        if layer.shadowPath != nil {
            createCachedShadow()
        }
    }
    
    func setupRoundedCornersWith(radius: CGFloat, color: UIColor, borderWith: CGFloat? = 1) {
        layer.cornerRadius = radius
        layer.borderWidth = borderWith ?? 1
        layer.borderColor = color.cgColor
        clipsToBounds = true
    }
    
    func makeViewWith(features: [ViewFeatures]?) {
        if let features = features as [ViewFeatures]? {
            features.forEach({
                switch $0 {
                case .rounded:
                    layer.cornerRadius = 10
                    clipsToBounds = true
                case .shadow: setupShadow(radius: 5, opacity: 0.5, offsetX: 1, offsetY: 0, cache: false, color: .lightGray)
                case .color(let color): self.backgroundColor = color
                case .bordered(let color, let borderWidth): setCornerRadius(color: color, borderWidth: borderWidth)
                case .image(let image):
                    if let imageView = self as? UIImageView { imageView.image = image }
                case .roundedView(let roundedType, let color): self.setRounded(roundedType: roundedType, color: color)
                case .topRounded: setupRoundedCorners(radius: 10, corners: [.topLeft, .topRight])
                case .fullRounded: setupRoundedCorners(radius: 10, corners: .allCorners)
                case .customRounded(let corners): setupRoundedCorners(radius: 10, corners: corners)
                }
            })
        }
    }
    
    func setCornerRadius(color: UIColor, borderWidth: CGFloat) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
    }
    
    func resetCornerRadius() {
        layer.cornerRadius = 0.0
        if layer.shadowPath != nil {
            createCachedShadow()
        }
    }
    
    func setRounded(roundedType: RoundedType, color: UIColor, borderWith: CGFloat? = 1) {
        layer.cornerRadius = self.frame.width / 2
        layer.borderWidth = borderWith ?? 1
        layer.borderColor = color.cgColor
        clipsToBounds = true
    }
    
    func setupShadow(radius: CGFloat, opacity: CGFloat, offsetX: CGFloat = 0, offsetY: CGFloat, cache: Bool = false, color: UIColor? = .black) {
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
    
    func createCachedShadow() {
        let origin = CGPoint(x: bounds.origin.x + layer.shadowOffset.width, y: bounds.origin.y + layer.shadowOffset.height)
        let size = CGSize(width: bounds.size.width + layer.shadowOffset.width, height: bounds.size.height + layer.shadowOffset.height)
        let rect = CGRect(origin: origin, size: size)
        let path: UIBezierPath
        if layer.cornerRadius > 0 {
            let maskedRect = layer.maskedCorners.rect
            if maskedRect == .allCorners {
                path = UIBezierPath(roundedRect: rect, cornerRadius: layer.cornerRadius)
            } else {
                path = UIBezierPath(roundedRect: rect, byRoundingCorners: maskedRect, cornerRadii: CGSize(width: layer.cornerRadius, height: layer.cornerRadius))
            }
        } else {
            path = UIBezierPath(rect: rect)
        }
        layer.shadowPath = path.cgPath
    }
}

public enum ViewFeatures {
    case rounded, shadow, color(UIColor), bordered(UIColor, CGFloat), image(UIImage),
         roundedView(RoundedType, UIColor), topRounded,
         fullRounded, customRounded(UIRectCorner)
}

public enum RoundedType {
    case full, onlyLayer
}

public struct RoundedCorners {
    
    public let radius: CGFloat
    public let corners: UIRectCorner
    
    public init(radius: CGFloat, corners: UIRectCorner) {
        self.radius = radius
        self.corners = corners
    }
}

extension UIRectCorner {
    var mask: CACornerMask? {
        guard self != .allCorners else { return nil }
        var cornerMask = CACornerMask()
        if contains(.topLeft) {
            cornerMask.insert(.layerMinXMinYCorner)
        }
        if contains(.topRight) {
            cornerMask.insert(.layerMaxXMinYCorner)
        }
        if contains(.bottomLeft) {
            cornerMask.insert(.layerMinXMaxYCorner)
        }
        if contains(.bottomRight) {
            cornerMask.insert(.layerMaxXMaxYCorner)
        }
        return cornerMask
    }
}

extension CACornerMask {
    var rect: UIRectCorner {
        var cornersCount = 0
        var rect = UIRectCorner()
        if contains(.layerMinXMinYCorner) {
            rect.insert(.topLeft)
            cornersCount += 1
        }
        if contains(.layerMaxXMinYCorner) {
            rect.insert(.topRight)
            cornersCount += 1
        }
        if contains(.layerMinXMaxYCorner) {
            rect.insert(.bottomLeft)
            cornersCount += 1
        }
        if contains(.layerMaxXMaxYCorner) {
            rect.insert(.bottomRight)
            cornersCount += 1
        }
        guard cornersCount != 4 else { return .allCorners }
        return rect
    }
}
