//
//  ViewFeatures.swift
//  ZygooApp
//
//  Created by Diego Luna on 02/12/19.
//  Copyright © 2019 Terrabyte. All rights reserved.
//

import UIKit
import AVFoundation

enum ViewFeatures {
    case rounded, shadow, color(UIColor), bordered(UIColor, CGFloat), image(UIImage), roundedView(RoundedType, UIColor), topRounded, fullRounded, customRounded(UIRectCorner)
    
}

enum RoundedType {
    case full, onlyLayer
}

extension UIView {
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
        
    }
    
    func makeViewWith(features: [ViewFeatures]?) {
        if let features = features as [ViewFeatures]? {
            features.forEach({
                switch $0 {
                case .rounded:
                    layer.cornerRadius = 10
                    clipsToBounds = true
                case .shadow: self.setShadow()
                case .color(let color): self.backgroundColor = color
                case .bordered(let color, let borderWidth): self.setCornerRadius(color: color, borderWidth: borderWidth)
                case .image(let image): (self as! UIImageView).image = image
                case .roundedView(let roundedType, let color): self.setRounded(roundedType: roundedType, color: color)
                case .topRounded: self.setTopRounded()
                case .fullRounded: self.setFullRounded()
                case .customRounded(let corners): self.setRounded(at: corners, cornerRad: 10)
                }
            })
        }
    }
    
    func animateLoadingOverSelf() {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        self.addSubview(activityIndicator)
        activityIndicator.frame = self.bounds
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        if let button = self as? UIButton {
            button.setTitle("", for: .normal)
        }
        self.isUserInteractionEnabled = false
    }
    
    func animateLoadingOverSelf(with color: UIColor?) {
        var defaultColor: UIColor!
        if #available(iOS 13.0, *) { defaultColor = .label }
        else { defaultColor = .black }
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        self.addSubview(activityIndicator)
        activityIndicator.frame = self.bounds
        activityIndicator.color = color ?? defaultColor
        activityIndicator.startAnimating()
        if let button = self as? UIButton {
            button.setTitle("", for: .normal)
        }
        self.isUserInteractionEnabled = false
    }
    
    func endAnimateOverSelf(originalFrame: CGRect, title: String) {
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = originalFrame
            self.isUserInteractionEnabled = true
            if let button = self as? UIButton {
                button.setTitle(title, for: .normal)
            }
        })
        self.subviews.forEach {
            if let activity = $0 as? UIActivityIndicatorView {
                activity.removeFromSuperview()
                
            }
        }
    }
    
    func endAnimateOverSelf(with title: String) {
        isUserInteractionEnabled = true
        if let button = self as? UIButton {
            button.setTitle(title, for: .normal)
            
        }
        self.subviews.forEach {
            if let activity = $0 as? UIActivityIndicatorView {
                activity.removeFromSuperview()
                
            }
        }
    }
    
    func setRounded(roundedType: RoundedType, color: UIColor) {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
        self.clipsToBounds = true
        
    }
    
}

@objc extension UIView {
    
    @objc func setRounded(at roundingCorners: UIRectCorner, cornerRad: CGFloat) {
        self.layer.mask = {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: cornerRad, height:  cornerRad))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            return maskLayer
        }()
    }
    
    @objc func setTopRounded() {
        self.setRounded(at: [.topLeft, .topRight], cornerRad: 30)
        
    }
    
    @objc func setFullRounded() {
        self.setRounded(at: [.topRight, .topLeft, .bottomLeft, .bottomRight], cornerRad: 10)
        
    }
    
    @objc func setShadow(){
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        
    }
    
    @objc func setCornerRadius(color: UIColor, borderWidth: CGFloat) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
        
    }
    
    @objc func addActivityIndicator(bgColor: UIColor?) {
        self.addSubview({
            let childView = UIView()
            childView.backgroundColor = bgColor ?? .red
            childView.frame = self.bounds
            childView.addSubview({
                let activityIndicator = UIActivityIndicatorView(style: .gray)
                activityIndicator.color = .white
                activityIndicator.frame = self.bounds
                activityIndicator.startAnimating()
                return activityIndicator
                
            }())
            return childView
            
        }())
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
    
    func asImage(frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContext(frame.size)
        if let captureLayer = layer.sublayers?.first(where: { $0 is AVCaptureVideoPreviewLayer }) {
            captureLayer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
            
        } else {
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
            
        }
    }
    
}
