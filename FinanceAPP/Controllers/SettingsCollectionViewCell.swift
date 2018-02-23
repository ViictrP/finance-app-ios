//
//  SettingsCollectionViewCell.swift
//  FinanceAPP
//
//  Created by Victor Prado on 23/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit

class SettingsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textField: TextField!
    @IBOutlet weak var lbValue: UILabel!
    
    //MARK: - Properties
    public static let fields: [String] = ["Name", "Email", "Password", "Other"]
    
    //MARK: - Func
    
    func prepare(field: String, value: String) {
        let imageView = UIImageView(image: UIImage(named: field.lowercased()))
        imageView.tintColor = UIColor(named: "main")
        self.textField.leftView = imageView
        self.textField.leftViewMode = .always
        self.lbValue.text = value
    }
    
    func enableTextField(_ enabled: Bool) {
        textField.isEnabled = enabled
        if enabled {
            textField.text = lbValue.text!
            lbValue.text = ""
            lbValue.isHidden = enabled
        } else {
            lbValue.text = textField.text!
            lbValue.isHidden = enabled
            textField.text = ""
        }
    }
}
