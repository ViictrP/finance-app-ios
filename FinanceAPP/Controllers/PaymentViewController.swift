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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        activityIndicator.isHidden = false
        tfPaymentValue.resignFirstResponder()
        if var value = tfPaymentValue.text {
            value = value.replacingOccurrences(of: ",", with: ".")
            if let converted = Double(value) {
                api.makePayment(value: converted, invoice: invoice!, completionHandler: { (success, error) in
                    if error == nil {
                        self.doSnackbar("payment added")
                        self.activityIndicator.isHidden = true
                        self.delegate?.invoice?.totalPaid = (self.delegate?.invoice?.totalPaid)! + converted
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.doSnackbar(error!)
                        self.activityIndicator.isHidden = true
                    }
                })
            } else {
                self.doSnackbar("Invalid value")
                self.activityIndicator.isHidden = true
            }
        } else {
            tfPaymentValue.attributedPlaceholder = changePlaceholder("The payment value is required", with: .white)
            tfPaymentValue.backgroundColor = UIColor(named: "main_red")
        }
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
