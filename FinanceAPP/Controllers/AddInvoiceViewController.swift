//
//  AddInvoiceViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 21/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit
import ObjectMapper

class AddInvoiceViewController: UITableViewControllerExtension {
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var swIsInstallment: UISwitch!
    @IBOutlet weak var tfInstallmentCount: UITextField!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var btSave: UIButton!
    @IBOutlet weak var btCancel: UIButton!
    @IBOutlet weak var btCategory: UIButton!
    @IBOutlet weak var dtExpireDate: UIDatePicker!
    
    var invoice: Invoice?
    var api: InvoiceAPI = InvoiceAPI.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfTitle.attributedPlaceholder = changePlaceholder("Title", with: .lightGray)
        tfValue.attributedPlaceholder = changePlaceholder("Value", with: .lightGray)
        tfInstallmentCount.attributedPlaceholder = changePlaceholder("Installment count", with: .lightGray)
        dtExpireDate.setValue(UIColor.white, forKey: "textColor")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? CategoryTableViewController {
            vc.delegate = self
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignFirstResponderAll()
    }
    
    @IBAction func save(_ sender: UIButton) {
        resignFirstResponderAll()
        invoice = Invoice()
        invoice?.title = tfTitle.text!
        invoice?.value = Double(tfValue.text!)
        invoice?.expireDate = dtExpireDate.date
        invoice?.totalPaid = 0.0
        invoice?.type = InvoiceCategory(rawValue: lbCategory.text!)
        invoice?.isInstallment = swIsInstallment.isOn
        invoice?.description = "Invoice added from app"
        api.saveInvoice(invoice: invoice!) { (bool) in
            print(bool)
        }
    }
    
    //MARK: - Func
    func changePlaceholder(_ placeholder: String, with color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: color])
    }
    
    func resignFirstResponderAll() {
        tfTitle.resignFirstResponder()
        tfValue.resignFirstResponder()
        tfInstallmentCount.resignFirstResponder()
    }
}
















