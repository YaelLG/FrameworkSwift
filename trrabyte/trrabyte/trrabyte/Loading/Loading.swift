//
//  Loading.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation
import UIKit

open class Loading: XibView {
    
    private var loadingImages: [UIImage] = [];
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var animationImageView: UIImageView!
        
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.nativeBounds)
        for index in 1..<13 {
            let stringFormat = index <= 9 ? "g_0%d" : "g_%d";
            let name = String(format: stringFormat, index)
            guard let image = UIImage(named: name) else { return }
            loadingImages.append(image)
        }
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func showWithText(_ text: String? = "") {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let window = UIApplication.shared.windows.first else { return }
            self.setupText(text)
            self.frame = window.frame
            self.startAnimation()
            window.addSubview(self)
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.alpha = 1
            }
        }
    }
    
    func remove() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.alpha = 0
            }, completion: { [weak self] (finish) in
                self?.removeFromSuperview()
            })
        }
    }
    
    fileprivate func startAnimation() {
        animationImageView.animationImages = loadingImages
        animationImageView.animationDuration = 1.2;
        animationImageView.startAnimating();
    }
    
    fileprivate func setupText(_ text: String?) {
        textLabel.text = text
    }
}
