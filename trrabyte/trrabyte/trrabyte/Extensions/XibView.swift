//
//  XibView.swift
//  T-Finance
//
//  Created by Diego Luna on 9/28/17.
//  Copyright © 2017 T-Finance. All rights reserved.
//

import UIKit

open class XibView: UIView {
    
    open var view: UIView?
    open var xibName: String?

    public init(frame: CGRect, constraints: Bool) {
        super.init(frame: frame)
        setupXib(constraints: constraints)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupXib(constraints: true)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib(constraints: true)
    }
    
    open func setupXib(constraints: Bool) {
        guard self.view.isNull else { return }
        let mainView = type(of: self).initFromNib(className: type(of: self))
        addSubview(mainView)
        if constraints {
            translatesAutoresizingMaskIntoConstraints = false
            mainView.translatesAutoresizingMaskIntoConstraints = false
            addConstraintsToFit(view: mainView)
        } else {
            mainView.frame = frame
        }
        view = mainView
    }
    
    open func loadViewFromNib() -> UIView? {
        let frameworkBundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: className(), bundle: frameworkBundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
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
