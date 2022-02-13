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
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    open func setupXib() {
        guard self.view.isNull, let mainView = loadViewFromNib() else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        mainView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainView)
        addConstraintsToFit(view: mainView)
        
        view = mainView
    }
    
    open func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: className(), bundle: Bundle(identifier: "com.framework.trrabyte"))
        let view = nib.instantiate(withOwner: self, options: nil).compactMap { $0 as? UIView}.first
        return view
    }
    
    open func className() -> String {
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
