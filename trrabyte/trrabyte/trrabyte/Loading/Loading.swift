//
//  Loading.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation
import UIKit

open class Loading: UIView {
    
    private var loadingImages: [UIImage] = [];
    public static var shared: Loading = {
        return createInstance()
    }()
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var loadimageView: UIImageView!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    fileprivate class func createInstance() -> Loading {
        guard let view = Loading.initFromNib(className: Loading.self) as? Loading else { return Loading() }
        return view
    }
    
    open func showWithText(_ text: String? = "") {
        initImages()
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
    
    open func remove() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.alpha = 0
            }, completion: { [weak self] (finish) in
                self?.removeFromSuperview()
            })
        }
    }
    
    fileprivate func initImages() {
        for index in 1..<13 {
            let stringFormat = index <= 9 ? "g_0%d" : "g_%d";
            let name = String(format: stringFormat, index)
            guard let image = UIImage(named: name) else { return }
            loadingImages.append(image)
        }
    }
    
    fileprivate func startAnimation() {
        loadimageView.animationImages = loadingImages
        loadimageView.animationDuration = 1.2;
        loadimageView.startAnimating();
    }
    
    fileprivate func setupText(_ text: String?) {
        infoLabel.text = text
    }
}
