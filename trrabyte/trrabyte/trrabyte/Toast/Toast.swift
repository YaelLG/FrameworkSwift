//
//  Toast.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation
import UIKit

open class Toast: UIView {
    private let margin: CGFloat = 40
    private let marginLabel: CGFloat = 20
    private let time: CGFloat = 3
    private var timer: DispatchSourceTimer?
    static var shared: Toast? = {
        return createInstance()
    }()
    
    @IBOutlet private weak var messageLabel: UILabel! {
        didSet {
            messageLabel.setupRoundedCorners(radius: 5)
            messageLabel.textColor = .white
            messageLabel.font = UIFont().withSize(16)
            messageLabel.backgroundColor = Style.secondary.contentDisable
            messageLabel.minimumScaleFactor = 0.5
        }
    }
    
    func show(text: String) {
        DispatchQueue.main.async {
            guard let shared = Toast.shared else { return }
            shared.stopTimer()
            shared.showWithMessage(text: text)
            shared.startTimer()
        }
    }
    
    func hide() {
        stopTimer()
        UIView.animate(withDuration: 0.5, animations: { self.alpha = 0 }) { _ in
            Toast.shared?.removeFromSuperview()
        }
    }
    
    fileprivate class func toastShowing(forceDismiss: Bool) {
        guard forceDismiss, let shared = Toast.shared else { return }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: { shared.alpha = 0 }) { _ in
                shared.removeFromSuperview()
            }
        }
    }
    
    fileprivate class func createInstance() -> Toast {
        guard let view = Toast.initFromNib() as? Toast else { return Toast() }
        return view
    }
    
    fileprivate func showWithMessage(text: String) {
        guard let window = UIApplication.shared.delegate?.window, let unwrappWindow = window else { return }
        alpha = 0
        frame = {
            var toastFrame = frame
            toastFrame.size = CGSize(width: unwrappWindow.frame.size.width,
                                     height: messageLabel.frame.size.height + margin)
            toastFrame.origin.x = 0
            toastFrame.origin.y = unwrappWindow.frame.height - frame.height - margin
            return toastFrame
        }()
        configurateLabelMessage(text: text)
        unwrappWindow.addSubview(self)
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.alpha = 1
        }
    }

    fileprivate func configurateLabelMessage(text: String) {
        messageLabel.text = text
        messageLabel.sizeToFit()
        messageLabel.setWidthAccordingToFont(margin: 20)
        messageLabel.setHeightAccordingToFont(margin: 15)
        messageLabel.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
    }
    
    fileprivate func stopTimer() {
        timer?.setEventHandler {}
        timer?.cancel()
    }
    
    fileprivate func startTimer() {
        let queue = DispatchQueue(label: "com.nomad.timer", attributes: .concurrent)
        timer?.cancel()
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now() + 3.0)
        timer?.setEventHandler {
            DispatchQueue.main.async { [weak self] in
                self?.hide()
            }
        }
        timer?.resume()
    }
}
