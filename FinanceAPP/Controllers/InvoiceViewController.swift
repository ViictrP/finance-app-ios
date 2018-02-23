//
//  InvoiceViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 21/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit

class InvoiceViewController: UIViewControllerExtension {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbExpireDate: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbInstallment: UILabel!
    
    var invoice: Invoice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbTitle.text = invoice?.title
        lbCategory.text = invoice?.category.rawValue
        lbExpireDate.text = invoice?.expireDate
        lbValue.text = invoice?.value
        lbInstallment.text = invoice?.installment
    }
}
