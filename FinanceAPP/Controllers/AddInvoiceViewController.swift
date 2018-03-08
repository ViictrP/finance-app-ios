//
//  AddInvoiceViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 21/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit
import ObjectMapper
import MaterialComponents.MaterialSnackbar

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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var invoice: Invoice?
    var category: Category?
    var api: InvoiceAPI = InvoiceAPI.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfTitle.delegate = self
        tfValue.delegate = self
        tfInstallmentCount.delegate = self
        resetFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let category = category {
            lbCategory.text = category.title
        }
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
    
    @IBAction func chooseCategory(_ sender: UIButton) {
        resignFirstResponderAll()
        performSegue(withIdentifier: "categorySegue", sender: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        resignFirstResponderAll()
        let checked = checkBeforeSave()
        if checked {
            invoice = Invoice()
            invoice?.title = tfTitle.text!
            var value = tfValue.text ?? ""
            value = value.replacingOccurrences(of: ",", with: ".")
            invoice?.value = Double(value)!
            invoice?.expireDate = dtExpireDate.date
            invoice?.totalPaid = 0.0
            invoice?.type = lbCategory.text!
            invoice?.isInstallment = swIsInstallment.isOn
            if swIsInstallment.isOn {
                let expireDate = invoice?.expireDate
                invoice?.lastExpireDate = Calendar.current.date(byAdding: .month, value: Int(tfInstallmentCount.text!)!, to: expireDate!)!
            }
            invoice?.invoiceDescription = "Invoice added from app"
            invoice?.category = category!
            invoice?.categoryId = category!.id
            activityIndicator.isHidden = false
            api.saveInvoice(invoice: invoice!) { (success, error) in
                if error == nil {
                    self.doSnackbar("The invoice \(self.invoice!.title) was created")
                    self.resetFields()
                    self.activityIndicator.isHidden = true
                } else {
                    self.doSnackbar(error!)
                    self.activityIndicator.isHidden = true
                }
            }
        } else {
            doSnackbar("Some fields are required")
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        resetFields()
    }
    
    func resetFields() {
        resignFirstResponderAll()
        self.tfTitle.text = ""
        self.tfValue.text = ""
        self.tfInstallmentCount.text = ""
        self.swIsInstallment.isOn = false
        self.dtExpireDate.setDate(Date(), animated: true)
        self.lbCategory.text = "CATEGORY"
        self.invoice = nil
        tfTitle.attributedPlaceholder = changePlaceholder("Title", with: .lightGray)
        tfValue.attributedPlaceholder = changePlaceholder("Value", with: .lightGray)
        tfInstallmentCount.attributedPlaceholder = changePlaceholder("Installment count", with: .lightGray)
        dtExpireDate.setValue(UIColor.white, forKey: "textColor")
        tfTitle.backgroundColor = UIColor(named: "textfield_bg_color")
        tfValue.backgroundColor = UIColor(named: "textfield_bg_color")
        tfInstallmentCount.backgroundColor = UIColor(named: "textfield_bg_color")
        lbCategory.backgroundColor = UIColor(named: "textfield_bg_color")
        category = nil
    }
    
    func checkBeforeSave() -> Bool {
        var checked = true
        if tfTitle.text == nil {
            tfTitle.text = ""
            tfTitle.backgroundColor = UIColor(named: "main_red")
            tfTitle.attributedPlaceholder = changePlaceholder("This field is required", with: .white)
            checked = false
        }
        if tfValue.text == nil {
            tfValue.text = ""
            tfValue.backgroundColor = UIColor(named: "main_red")
            tfValue.attributedPlaceholder = changePlaceholder("This field is required", with: .white)
            checked = false
        }
        if category == nil {
            lbCategory.text = "CATEGORY"
            lbCategory.backgroundColor = UIColor(named: "main_red")
            checked = false
        }
        if swIsInstallment.isOn && tfInstallmentCount.text!.isEmpty {
            tfInstallmentCount.text = ""
            tfInstallmentCount.backgroundColor = UIColor(named: "main_red")
            tfInstallmentCount.attributedPlaceholder = changePlaceholder("This field is required", with: .white)
        }
        return checked
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
    
    func doSnackbar(_ msg: String) {
        let message = MDCSnackbarMessage()
        message.text = msg
        MDCSnackbarManager.show(message)
    }
}

extension AddInvoiceViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}































