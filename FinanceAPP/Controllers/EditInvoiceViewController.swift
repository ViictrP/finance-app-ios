//
//  EditInvoiceViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 24/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit

class EditInvoiceViewController: UITableViewController {

    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var tfExpireDate: UITextField!
    @IBOutlet weak var tfInstallmentCount: UITextField!
    @IBOutlet weak var swIsInstallment: UISwitch!
    @IBOutlet weak var btSave: UIButton!
    @IBOutlet weak var btCancel: UIButton!
    @IBOutlet weak var lbCategory: UILabel!
    
    var invoice: Invoice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfTitle.attributedPlaceholder = changePlaceholder("Title", with: .lightGray)
        tfValue.attributedPlaceholder = changePlaceholder("Value", with: .lightGray)
        tfExpireDate.attributedPlaceholder = changePlaceholder("Expire date", with: .lightGray)
        tfInstallmentCount.attributedPlaceholder = changePlaceholder("Installment count", with: .lightGray)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       resignFirstResponderAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = invoice?.title
        tfTitle.text = invoice!.title
        tfValue.text = "Test"
        tfExpireDate.text = "Test"
        tfInstallmentCount.text = "Test"
        lbCategory.text = "Test"
    }
    
    //MARK: - Actions
    @IBAction func cancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Func
    func changePlaceholder(_ placeholder: String, with color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: color])
    }
    
    func resignFirstResponderAll() {
        tfTitle.resignFirstResponder()
        tfValue.resignFirstResponder()
        tfExpireDate.resignFirstResponder()
        tfInstallmentCount.resignFirstResponder()
    }
}
