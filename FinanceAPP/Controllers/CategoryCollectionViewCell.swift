//
//  CategoryCollectionViewCell.swift
//  FinanceAPP
//
//  Created by Victor Prado on 07/03/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbBadge: UILabel!
    @IBOutlet weak var lbAddedDate: UILabel!
    
    public func prepare(category: Category) {
        self.lbTitle.text = category.title
        self.lbBadge.text = "\(category.invoicesCount)"
        self.lbAddedDate.text = DateUtils.dateToString(category.createDate, format: "dd/MM/yyyy")
    }
}
