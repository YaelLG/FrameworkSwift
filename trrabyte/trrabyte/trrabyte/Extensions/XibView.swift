//
//  XibView.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import UIKit

open class XibView: UIView {
    
    open var view: UIView?
    open var xibName: String?
    
    public init(frame: CGRect, className: AnyClass) {
        super.init(frame: frame)
        setupXib(className: className)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupXib(className: AnyClass) {
        guard self.view.isNull, let mainView = loadViewFromNib(className: className) else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        mainView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainView)
        addConstraintsToFit(view: mainView)
        
        view = mainView
    }
    
    open func loadViewFromNib(className: AnyClass) -> UIView? {
        let frameworkBundle = Bundle(for: className)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("trrabyte.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        let nib = UINib(nibName: getClassName(), bundle: resourceBundle)
        let view = nib.instantiate(withOwner: self, options: nil).compactMap { $0 as? UIView}.first
        return view
    }
    
    open func getClassName() -> String {
        if let xibName = xibName {
            return xibName
        } else {
            return String(describing: type(of: self))
        }
    }
    
    override open func removeFromSuperview() {
        view?.removeFromSuperview()
        super.removeFromSuperview()
    }
}
