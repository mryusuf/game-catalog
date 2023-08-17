//
//  Extensions.swift
//  GameCatalog
//
//  Created by Indra Permana on 15/08/23.
//

import UIKit

var imageCaches = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func load(url: URL?) {
        guard let url else {
            return
        }
        
        if let image = imageCaches.object(forKey: url as NSURL) as? UIImage {
            self.image = image
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCaches.setObject(image, forKey: url as NSURL)
                        self?.image = image
                    }
                }
            }
        }
    }
}


extension UITableViewCell {
    
    /// Returns a string representation of this class
    class var identifier: String {
        return String(describing: self)
    }
    
}
