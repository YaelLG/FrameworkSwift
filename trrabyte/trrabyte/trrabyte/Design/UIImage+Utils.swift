//
//  UIImageView+Utils.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import UIKit

public struct IconCatalog {
    let general: GeneralIconCatalog = GeneralIconCatalog()
}

public struct GeneralIconCatalog {
    var back: UIImage { UIImage(named: "btn_keyboard_previous") ?? UIImage() }
    var next: UIImage { UIImage(named: "btn_keyboard_next") ?? UIImage() }
    var hide: UIImage { UIImage(named: "btn_keyboard_ocultar") ?? UIImage() }
}

extension UIImageView {
    open func setImageColor(color: UIColor? = nil) {
        var templateImage: UIImage.RenderingMode
        color.isNull ? (templateImage = .automatic) : (templateImage = .alwaysTemplate)
        image = image?.withRenderingMode(templateImage)
        tintColor = color
    }
    
    open func downloadImage(from url: URL, successRequest: @escaping (Bool) -> Void) {
        getData(from: url) { data, _, error in
            guard let data = data, error == nil else {
                successRequest(false)
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.image = UIImage(data: data)
                successRequest(true)
            }
        }
    }
    
    open func downloadReturnImage(from url: URL, successImage: @escaping (UIImage?) -> Void) {
        getData(from: url) { data, _, error in
            guard let data = data, error == nil else {
                successImage(nil)
                return
            }
            DispatchQueue.main.async { [weak self] in
                guard !self.isNull else { return }
                successImage(UIImage(data: data))
            }
        }
    }
    
    open func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
