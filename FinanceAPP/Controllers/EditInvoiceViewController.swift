//
//  EditInvoiceViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 24/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar
import RealmSwift

class EditInvoiceViewController: UITableViewController {

    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var tfInstallmentCount: UITextField!
    @IBOutlet weak var swIsInstallment: UISwitch!
    @IBOutlet weak var btSave: UIButton!
    @IBOutlet weak var btCancel: UIButton!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var dtExpireDate: UIDatePicker!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var invoice: Invoice?
    var api: InvoiceAPI = InvoiceAPI.shared
    var delegate: InvoiceViewController?
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfTitle.attributedPlaceholder = changePlaceholder("Title", with: .lightGray)
        tfValue.attributedPlaceholder = changePlaceholder("Value", with: .lightGray)
        dtExpireDate.setValue(UIColor.white, forKey: "textColor")
        tfInstallmentCount.attributedPlaceholder = changePlaceholder("Installment count", with: .lightGray)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nonNilInvoice = invoice {
            title = nonNilInvoice.title
            tfTitle.text = nonNilInvoice.title
            tfValue.text = String(describing: nonNilInvoice.value)
            dtExpireDate.setDate(nonNilInvoice.expireDate, animated: true)
            swIsInstallment.isOn = nonNilInvoice.isInstallment
            lbCategory.text = nonNilInvoice.category?.title
            calculateInvoiceCount(expireDate: nonNilInvoice.expireDate, LastExpireDate: nonNilInvoice.lastExpireDate)
            
            let realm = try! Realm()
            let category = realm.object(ofType: Category.self, forPrimaryKey: nonNilInvoice.categoryId)
            if let category = category {
                self.category = category
                lbCategory.text = category.title
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func cancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: UIButton) {
        resignFirstResponderAll()
        let checked = checkBeforeSave(invoice)
        if checked {
            updateInRealm(checked)
            activityIndicator.isHidden = false
            api.updateInvoice(invoice: invoice!) { (success, error) in
                if error == nil {
                    self.doSnackbar("The invoice \(self.invoice!.title) was updated")
                    self.activityIndicator.isHidden = true
                    self.delegate?.invoice = self.invoice
                    self.cancel(self.btCancel)
                } else {
                    self.doSnackbar(error!)
                    self.activityIndicator.isHidden = true
                }
            }
        } else {
            doSnackbar("Some fields are required")
        }
    }
    
    @IBAction func chooseCategory(_ sender: UIButton) {
        resignFirstResponderAll()
        performSegue(withIdentifier: "categorySegue", sender: nil)
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
    
    func checkBeforeSave(_ invoice: Invoice?) -> Bool {
        var checked = true
        if swIsInstallment.isOn && tfInstallmentCount.text!.isEmpty {
            tfInstallmentCount.text = ""
            tfInstallmentCount.backgroundColor = UIColor(named: "main_red")
            tfInstallmentCount.attributedPlaceholder = changePlaceholder("This field is required", with: .white)
            checked = false
        }
        if invoice?.categoryId == nil {
            lbCategory.text = "CATEGORY"
            lbCategory.backgroundColor = UIColor(named: "main_red")
            checked = false
        }
        return checked
    }
    
    func doSnackbar(_ msg: String) {
        let message = MDCSnackbarMessage()
        message.text = msg
        MDCSnackbarManager.show(message)
    }
    
    func updateInRealm(_ checked: Bool) {
        if checked {
            let realm = try! Realm()
            try! realm.write {
                invoice?.title = tfTitle.text!
                var value = tfValue.text!
                value = value.replacingOccurrences(of: ",", with: ".")
                invoice?.value = Double(value)!
                invoice?.expireDate = dtExpireDate.date
                invoice?.totalPaid = 0.0
                invoice?.type = lbCategory.text!
                invoice?.isInstallment = swIsInstallment.isOn
                if swIsInstallment.isOn {
                    let expireDate = invoice?.expireDate
                    invoice?.lastExpireDate = Calendar.current.date(byAdding: .month, value: Int(tfInstallmentCount.text!)!, to: expireDate!)!
                } else {
                    invoice?.lastExpireDate = (invoice?.expireDate)!
                }
                invoice?.invoiceDescription = "Invoice updated from app"
                invoice?.category = category!
            }
        }
    }
    
    func calculateInvoiceCount(expireDate: Date, LastExpireDate: Date) {
        let form = DateComponentsFormatter()
        form.maximumUnitCount = 2
        form.unitsStyle = .full
        form.allowedUnits = [.month]
        let s = form.string(from: expireDate, to: LastExpireDate)
        tfInstallmentCount.text = s!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
}

extension EditInvoiceViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
