//
//  ImageExtension.swift
//  FinanceAPP
//
//  Created by Victor Prado on 16/03/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
