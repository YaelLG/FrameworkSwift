//
//  KeyboardManage.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation
import UIKit
import UserNotificationsUI

open class KeyboardManage: NSObject {
    
    private var scroll: UIScrollView?
    private var inputs: [UIView] = []
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func scrollConfiguration(scroll: UIScrollView, inputs: [UIView]) {
        self.scroll = scroll
        self.inputs = inputs
        setupInputsScrolling()
    }
    
    func setupInputsScrolling() {
        registerKeyboardNotifications()
        for input in inputs {
            let tool = KeyboardTool.instance(delegate: self)
            tool.buttonsConfiguration(isBackHidden: inputs.count == 1,
                                      isNextHidden: inputs.count == 1)
            
            if let textField = input as? UITextField {
                textField.inputAccessoryView = tool
            } else if let textView = input as? UITextView {
                textView.inputAccessoryView = tool
            } else { continue }
        }
    }
    
    @objc
    fileprivate func keyboardWasShown(_ notification: Notification) {
        guard let info = notification.userInfo,
            let keyboardFrame = info[UIWindow.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        guard var contentInsets = scroll?.contentInset else { return }
        contentInsets.bottom = keyboardHeight
        scroll?.contentInset = contentInsets
        scroll?.scrollIndicatorInsets = contentInsets
        guard let view = getFocusedInput() else { return }
        scrollToSpecificView(view)
    }
    
    @objc
    fileprivate func keyboardWillBeHidden(_ notification: Notification) {
        let contentInsets: UIEdgeInsets = .zero
        scroll?.contentInset = contentInsets
        scroll?.scrollIndicatorInsets = contentInsets
    }
    
    fileprivate func getFocusedInput() -> UIView? {
        for input in inputs {
            if let textField = input as? UITextField {
                if textField.isFirstResponder { return textField }
            } else if let textView = input as? UITextView {
                if textView.isFirstResponder { return textView }
            }
        }
        return nil
    }
    
    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(_:)),
                                               name: UIWindow.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(_:)),
                                               name: UIWindow.keyboardWillHideNotification,
                                               object: nil)
    }
    
    fileprivate func scrollToSpecificView(_ view: UIView) {
        guard let activeField = view.superview?.convert(view.frame, to: scroll) else { return }
        scroll?.scrollRectToVisible(activeField, animated: true)
    }
}

extension KeyboardManage: KeyboardToolDelegate {
    func didClicButtonBack(button: UIButton) {
        guard let view = getFocusedInput(),
            let index = inputs.firstIndex(where: { $0 == view }) else { return }
        
        let beforeIndex = index - 1
        let currentIndex = beforeIndex >= 0 && beforeIndex < inputs.count ? beforeIndex : inputs.count - 1
            
        let currentField = inputs[currentIndex]
        currentField.becomeFirstResponder()
    }
    
    func didClicButtonNext(button: UIButton) {
        guard let view = getFocusedInput(),
            let index = inputs.firstIndex(where: { $0 == view }) else { return }
        
        let afterIndex = index + 1
        let currentIndex = afterIndex >= 0 && afterIndex < inputs.count ? afterIndex : 0

        let currentField = inputs[currentIndex]
        currentField.becomeFirstResponder()
    }
    
    func didClicButtonHide(button: UIButton) {
        guard let view = getFocusedInput() else { return }
        view.resignFirstResponder()
    }
}
