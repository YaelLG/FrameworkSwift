//
//  Gradient.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation
import UIKit

public struct Gradient {
    
    // MARK: - Gradient
    
    public static let layerName: String = "GradientLayer"
    
    public enum GradientDirection: Int {
        case right
        case left
        case bottom
        case top
        case topLeftToBottomRight
        case topRightToBottomLeft
        case bottomLeftToTopRight
        case bottomRightToTopLeft
    }
    
    public func primary(with view: UIView, direction: GradientDirection = .left) {
        primary(layer: view.layer, direction: direction)
    }
    
    public func alert(with view: UIView, direction: GradientDirection = .left) {
        alert(layer: view.layer, direction: direction)
    }
    
    public func success(with view: UIView, direction: GradientDirection = .left) {
        success(layer: view.layer, direction: direction)
    }
    
    public func error(with view: UIView, direction: GradientDirection = .left) {
        error(layer: view.layer, direction: direction)
    }
    
    public func removeLayer(with view: UIView) {
        removeLayer(from: view.layer)
    }
}

//MARK: CALayer
public extension Gradient {
    func primary(layer: CALayer, direction: GradientDirection = .left) {
        setGradient(colors: [GradientColor.primaryStart.color, GradientColor.primaryEnd.color], layer: layer, direction: direction)
    }
    
    func alert(layer: CALayer, direction: GradientDirection = .left) {
        setGradient(colors: [GradientColor.alertStart.color, GradientColor.alertEnd.color], layer: layer, direction: direction)
    }
    
    func success(layer: CALayer, direction: GradientDirection = .left) {
        setGradient(colors: [GradientColor.successStart.color, GradientColor.successEnd.color], layer: layer, direction: direction)
    }
    
    func error(layer: CALayer, direction: GradientDirection = .left) {
        setGradient(colors: [GradientColor.errortStart.color, GradientColor.errortEnd.color], layer: layer, direction: direction)
    }
    
    func disabled(layer: CALayer, direction: GradientDirection = .left) {
        setGradient(colors: [GradientColor.disabledStart.color, GradientColor.disabledEnd.color], layer: layer, direction: direction)
    }

    func removeLayer(from layer: CALayer) {
        for item in layer.sublayers ?? [] where item.name == Gradient.layerName {
            item.removeFromSuperlayer()
        }
    }
}

public extension Gradient {
    
    func setGradient(colors: [CGColor], layer: CALayer, direction: GradientDirection) {
        DispatchQueue.main.async {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = layer.bounds
            gradientLayer.colors = colors
            gradientLayer.name = Gradient.layerName
            gradientLayer.cornerRadius = layer.cornerRadius
            self.setGradientDirection(with: gradientLayer, direction: direction)
            if let oldLayer = layer.sublayers?.first(where: { $0.name == Gradient.layerName }) {
                layer.replaceSublayer(oldLayer, with: gradientLayer)
            } else {
                layer.insertSublayer(gradientLayer, at: 0)
            }
            
        }
    }
    
    func setGradientDirection(with gradientLayer: CAGradientLayer, direction: GradientDirection) {
        switch direction {
        case GradientDirection.right:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        case GradientDirection.left:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
            
        case GradientDirection.bottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case GradientDirection.top:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            
        case GradientDirection.topLeftToBottomRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            
        case GradientDirection.topRightToBottomLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
            
        case GradientDirection.bottomLeftToTopRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
            
        default:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        }
    }
}

public enum GradientColor {
    
    case primaryStart
    case primaryEnd
    case successStart
    case successEnd
    case alertStart
    case alertEnd
    case errortStart
    case errortEnd
    case disabledStart
    case disabledEnd
    
    public var color: CGColor {
        switch self {
        case .primaryStart:
            return UIColor(red: 255, green: 36, blue: 38).cgColor
        case .primaryEnd:
            return UIColor(red: 255, green: 146, blue: 89).cgColor
        case .successStart:
            return UIColor(red: 164, green: 244, blue:116).cgColor
        case .successEnd:
            return UIColor(red: 12, green: 198, blue:101).cgColor
        case .alertStart:
            return UIColor(red: 255, green: 125, blue: 0).cgColor
        case .alertEnd:
            return UIColor(red: 255, green: 166, blue: 0).cgColor
        case .errortStart:
            return UIColor(red: 255, green: 110, blue: 110).cgColor
        case .errortEnd:
            return UIColor(red: 255, green: 37, blue: 37).cgColor
        case .disabledStart:
            return UIColor(red: 120, green: 120, blue: 120).cgColor
        case .disabledEnd:
            return UIColor(red: 180, green: 180, blue: 180).cgColor
        }
    }
}
