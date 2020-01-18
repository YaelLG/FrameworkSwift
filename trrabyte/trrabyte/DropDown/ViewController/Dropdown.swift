//
//  Zygoo
//
//  Created by Diego Luna on 10/14/19.
//  Copyright © 2019 Terrabyte. All rights reserved.
//


import Foundation
import UIKit

protocol OptionDropdownSelectedDelegate{
    func optionSelected(option: Int?, viewIdentifier: Int?)
}

class Dropdown: UIViewController
{
    let xibDropdownName = "DropdownCell"
    
    @IBOutlet weak var view_bk: UIView!
    @IBOutlet weak var view_popUp: UIView!
    
    @IBOutlet weak var collection: UICollectionView!
    
    var arrData : [String] = []
    var preferredFrame : CGRect = .zero
    
    var tag: Int?
    var delegate: OptionDropdownSelectedDelegate?

    private var isFirst : Bool = true
    
    //MARK: - Override methods

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, animations: {
            self.view_bk.alpha = 1
            self.view_popUp.frame = {
                var frame = self.view_popUp.frame
                frame.size.height = CGFloat(min(self.arrData.count * 30, 120))
                return frame
            }()
        })
    }
    
    //MARK: - Setup methods
    
    func setup()
    {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handlerCancel))

        view.backgroundColor = .clear
        view_bk.addGestureRecognizer(tapGesture)
        view_bk.alpha = 0
        view_popUp.frame = preferredFrame
        
        collection.reloadData()
    }
    
    //MARK: - Selector
    
    @objc func handlerCancel()
    {
        self.removeFromParent()
        delegate?.optionSelected(option: nil, viewIdentifier:tag)
    }
    
    func present()
    {
        UIApplication.shared.keyWindow?.addSubview(self.view)
    }
}

extension Dropdown: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: xibDropdownName, for: indexPath) as! DropdownCell
                     
        cell.setupWithInfo(option: arrData[indexPath.item])
                
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize.init(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.removeFromParent()
        delegate?.optionSelected(option: indexPath.item, viewIdentifier:tag)
    }
}
