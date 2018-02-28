//
//  PaymentViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 28/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar

class PaymentViewController: UIViewControllerExtension {

    @IBOutlet weak var tfPaymentValue: UITextField!
    
    var delegate: InvoiceViewController?
    var invoice: Invoice?
    var api: InvoiceAPI = InvoiceAPI.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfPaymentValue.attributedPlaceholder = changePlaceholder("Payment value", with: .lightGray)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
    @IBAction func makePayment(_ sender: UIButton) {
        doSnackbar("payment added")
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Func
    
    func changePlaceholder(_ placeholder: String, with color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: color])
    }
    
    func doSnackbar(_ msg: String) {
        let message = MDCSnackbarMessage()
        message.text = msg
        MDCSnackbarManager.show(message)
    }
}
