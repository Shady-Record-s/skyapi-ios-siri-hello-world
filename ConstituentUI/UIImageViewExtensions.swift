//
//  UIImageViewExtensions.swift
//  ConstituentUI
//
//  Created by Christi Schneider on 12/13/19.
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        guard let self = self else {
                            return
                        }
                        self.image = image
                        let aspect = image.size.width / image.size.height
                        self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: aspect).isActive = true
                    }
                }
            }
        }
    }
}
