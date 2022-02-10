//
//  GradientView.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import UIKit

/// Simple view for drawing gradients and borders.
open class GradientView: UIView {

    // MARK: - Types

    /// The mode of the gradient.
    public enum `Type` {
        /// A linear gradient.
        case linear

        /// A radial gradient.
        case radial
    }

    /// The direction of the gradient.
    public enum Direction {
        /// The gradient is vertical.
        case vertical

        /// The gradient is horizontal
        case horizontal
        
        /// The gradient is from (x: 1, y: 0)
        case inclined
    }

    // MARK: - Properties

    /// An optional array of `UIColor` objects used to draw the gradient. If the value is `nil`, the `backgroundColor`
    /// will be drawn instead of a gradient. The default is `nil`.
    open var colors: [UIColor]? {
        didSet {
            updateGradient()
        }
    }

    /// An array of `UIColor` objects used to draw the dimmed gradient. If the value is `nil`, `colors` will be
    /// converted to grayscale. This will use the same `locations` as `colors`. If length of arrays don't match, bad
    /// things will happen. You must make sure the number of dimmed colors equals the number of regular colors.
    ///
    /// The default is `nil`.
    open var dimmedColors: [UIColor]? {
        didSet {
            updateGradient()
        }
    }

    /// Automatically dim gradient colors when prompted by the system (i.e. when an alert is shown).
    ///
    /// The default is `true`.
    open var automaticallyDims: Bool = true

    /// An optional array of `CGFloat`s defining the location of each gradient stop.
    ///
    /// The gradient stops are specified as values between `0` and `1`. The values must be monotonically increasing. If
    /// `nil`, the stops are spread uniformly across the range.
    ///
    /// Defaults to `nil`.
    open var locations: [CGFloat]? {
        didSet {
            updateGradient()
        }
    }

    /// The mode of the gradient. The default is `.Linear`.
    open var mode: Type = .linear {
        didSet {
            setNeedsDisplay()
        }
    }

    /// The direction of the gradient. Only valid for the `Mode.Linear` mode. The default is `.Vertical`.
    open var direction: Direction = .vertical {
        didSet {
            setNeedsDisplay()
        }
    }

    /// 1px borders will be drawn instead of 1pt borders. The default is `true`.
    @IBInspectable
    open var drawsThinBorders: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }

    /// The top border color. The default is `nil`.
    @IBInspectable
    open var topBorderColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    /// The right border color. The default is `nil`.
    @IBInspectable
    open var rightBorderColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    ///  The bottom border color. The default is `nil`.
    @IBInspectable
    open var bottomBorderColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    /// The left border color. The default is `nil`.
    @IBInspectable
    open var leftBorderColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The center of gradien. The default is `nil`.
    open var centerGradient: CGPoint? {
        didSet {
            updateGradient()
        }
    }
    
    /// The center of gradien. The default is `nil`.
    open var radiusGradient: CGFloat? {
        didSet {
            updateGradient()
        }
    }

    // MARK: - UIView

    override open func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let size = bounds.size

        // Gradient
        if let gradient = gradient {
            let options: CGGradientDrawingOptions = [.drawsAfterEndLocation]

            if mode == .linear {
                var startPoint = CGPoint.zero
                let endPoint: CGPoint
                switch direction {
                case .horizontal:
                    endPoint = CGPoint(x: size.width, y: 0)
                case .vertical:
                    startPoint = CGPoint(x: size.width, y: size.height)
                    endPoint = CGPoint(x: size.width, y: 0)
                case .inclined:
                    startPoint = CGPoint(x:size.width, y:0)
                    endPoint = CGPoint(x: 0, y: size.height)
                }
                context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: options)
            } else {
                guard  let centerGra = self.centerGradient,
                       let radiusGradient = self.radiusGradient else {
                
                    let center = CGPoint(x: bounds.midX, y: bounds.midY)
                    context.drawRadialGradient(gradient, startCenter: center, startRadius: 0, endCenter: center, endRadius: min(size.width, size.height) / 2, options: options)
                    return
                }
                
                    context.drawRadialGradient(gradient, startCenter: centerGra, startRadius: 0, endCenter: centerGra, endRadius: radiusGradient, options: options)
                
            }
        }

        let screen: UIScreen = window?.screen ?? UIScreen.main
        let borderWidth: CGFloat = drawsThinBorders ? 1.0 / screen.scale : 1.0

        // Top border
        if let color = topBorderColor {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: borderWidth))
        }

        let sideY: CGFloat = topBorderColor != nil ? borderWidth : 0
        let sideHeight: CGFloat = size.height - sideY - (bottomBorderColor != nil ? borderWidth : 0)

        // Right border
        if let color = rightBorderColor {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: size.width - borderWidth, y: sideY, width: borderWidth, height: sideHeight))
        }

        // Bottom border
        if let color = bottomBorderColor {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: size.height - borderWidth, width: size.width, height: borderWidth))
        }

        // Left border
        if let color = leftBorderColor {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: sideY, width: borderWidth, height: sideHeight))
        }
    }

    override open func tintColorDidChange() {
        super.tintColorDidChange()

        if automaticallyDims {
            updateGradient()
        }
    }

    override open func didMoveToWindow() {
        super.didMoveToWindow()
        contentMode = .redraw
    }

    func updateColors(_ colors: [UIColor]) {
        if colors.count == 1 {
            self.colors = nil
            backgroundColor = colors.first
        } else {
            self.colors = colors
        }
    }
    
    // MARK: - Private

    fileprivate var gradient: CGGradient?

    fileprivate func updateGradient() {
        gradient = nil
        setNeedsDisplay()

        let colors = gradientColors()
        
        if let colors = colors {
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colorSpaceModel = colorSpace.model

            let gradientColors: [CGColor] = colors.map { color in
                let cgColor = color.cgColor
                let cgColorSpace = cgColor.colorSpace

                // The color's color space is RGB, simply add it.
                if cgColorSpace!.model.rawValue == colorSpaceModel.rawValue {
                    return cgColor
                }

                // Convert to RGB. There may be a more efficient way to do this.
                var red: CGFloat = 0
                var blue: CGFloat = 0
                var green: CGFloat = 0
                var alpha: CGFloat = 0
                color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                return UIColor(red: red, green: green, blue: blue, alpha: alpha).cgColor
            }

            if let locations = locations {
                gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: locations)
            } else {
                gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: nil)
            }
        }
    }

    fileprivate func gradientColors() -> [UIColor]? {
        if tintAdjustmentMode == .dimmed {
            if let dimmedColors = dimmedColors {
                return dimmedColors
            }

            if automaticallyDims {
                if let colors = colors {
                    return colors.map {
                        var hue: CGFloat = 0
                        var brightness: CGFloat = 0
                        var alpha: CGFloat = 0

                        $0.getHue(&hue, saturation: nil, brightness: &brightness, alpha: &alpha)

                        return UIColor(hue: hue, saturation: 0, brightness: brightness, alpha: alpha)
                    }
                }
            }
        }

        return colors
    }
}
