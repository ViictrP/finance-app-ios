//
//  FloatingActionButton.swift
//  FinanceAPP
//
//  Created by Victor Prado on 12/03/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit

class FloatingActionButton: UIButton {

    var alphaBefore: CGFloat = 1
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        alphaBefore = alpha
        UIView.animate(withDuration: 0.2, animations: {
            if self.transform == .identity {
                self.transform = CGAffineTransform(rotationAngle: 135 * (.pi / 180))
                self.backgroundColor = #colorLiteral(red: 0.8196, green: 0.2196, blue: 0.3333, alpha: 1) /* #d13855 */
            } else {
                self.transform = .identity
                self.backgroundColor = UIColor(named: "main_red")
            }
        })
        return true
    }
}
