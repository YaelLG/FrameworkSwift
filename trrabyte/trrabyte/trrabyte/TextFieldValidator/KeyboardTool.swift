//
//  KeyboardTool.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation
import UIKit

public protocol KeyboardToolDelegate: AnyObject {
    func didClicButtonBack(button: UIButton)
    func didClicButtonNext(button: UIButton)
    func didClicButtonHide(button: UIButton)
}

open class KeyboardTool: UIView {

    private weak var delegate: KeyboardToolDelegate?
    @IBOutlet private weak var previousButton: UIButton! {
        didSet {
            previousButton.setImage(Style.icon.general.back, for: .normal)
        }
    }
    @IBOutlet private weak var nextButton: UIButton! {
        didSet {
            nextButton.setImage(Style.icon.general.next, for: .normal)
        }
    }
    @IBOutlet private weak var hideButton: UIButton! {
        didSet {
            hideButton.setupRoundedCorners(radius: 5)
            hideButton.setImage(Style.icon.general.hide, for: .normal)
        }
    }
    
    @IBAction private func back(_ sender: UIButton) {
        delegate?.didClicButtonBack(button: sender)
    }
    @IBAction private func next(_ sender: UIButton) {
        delegate?.didClicButtonNext(button: sender)
    }
    @IBAction private func hide(_ sender: UIButton) {
        delegate?.didClicButtonHide(button: sender)
    }
    
    open class func instance(delegate: KeyboardToolDelegate) -> KeyboardTool {
        guard let view = KeyboardTool.initFromNib() as? KeyboardTool else {
            return KeyboardTool()
        }
        view.delegate = delegate
        return view
    }
    
    func buttonsConfiguration(isBackHidden: Bool, isNextHidden: Bool) {
        previousButton.isHidden = isBackHidden
        nextButton.isHidden = isNextHidden
    }
}
