//
//  AddInvoiceViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 21/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit

class AddInvoiceViewController: UITableViewControllerExtension {
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var swIsInstallment: UISwitch!
    @IBOutlet weak var tfInstallmentCount: UITextField!
    @IBOutlet weak var tfExpireDate: UITextField!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var btSave: UIButton!
    @IBOutlet weak var btCancel: UIButton!
    
    var invoice: Invoice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfTitle.attributedPlaceholder = changePlaceholder("Title", with: .lightGray)
        tfValue.attributedPlaceholder = changePlaceholder("Value", with: .lightGray)
        tfExpireDate.attributedPlaceholder = changePlaceholder("Expire date", with: .lightGray)
        tfInstallmentCount.attributedPlaceholder = changePlaceholder("Installment count", with: .lightGray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
    //MARK: - Func
    func changePlaceholder(_ placeholder: String, with color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: color])
    }
}
