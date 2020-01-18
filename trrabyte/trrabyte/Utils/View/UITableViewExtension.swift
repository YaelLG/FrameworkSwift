//
//  UITableViewExtension.swift
//  ZygooApp
//
//  Created by Diego Luna on 05/12/19.
//  Copyright © 2019 Terrabyte. All rights reserved.
//

import UIKit

extension UITableView {
    
    func batchUpdates(flag: Bool, indexPaths: [IndexPath], indexPath: IndexPath, completion: @escaping() -> Void) {
        if !flag {
            self.scrollToRow(at: indexPath, at: .none, animated: false)
            
        }
        if #available(iOS 11.0, *) {
            self.performBatchUpdates({
                flag
                    ? self.insertRows(at: indexPaths, with: .fade)
                    : self.deleteRows(at: indexPaths, with: .fade)
                
            }, completion: { [unowned self] _ in
                if let _ = self.cellForRow(at: indexPath) {
                    self.scrollToRow(at: indexPath, at: .none, animated: false)
                }
                completion()
                
            })
        }
    }
    
}
