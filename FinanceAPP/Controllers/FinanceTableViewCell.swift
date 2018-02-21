//
//  FinanceTableViewCell.swift
//  FinanceAPP
//
//  Created by Victor Prado on 21/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit

class FinanceTableViewCell: UITableViewCell {

    @IBOutlet weak var invoiceTitle: UILabel!
    @IBOutlet weak var expireDate: UILabel!
    @IBOutlet weak var invoiceCategory: UILabel!
    @IBOutlet weak var invoiceValue: UILabel!
    @IBOutlet weak var invoiceInstallmentCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}