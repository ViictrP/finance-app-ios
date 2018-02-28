//
//  InvoiceViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 21/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar

class InvoiceViewController: UIViewControllerExtension {

    private let format: String = "dd/MM"
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbExpireDate: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbInstallment: UILabel!
    @IBOutlet weak var btEdit: UIButton!
    @IBOutlet weak var btDelete: UIButton!
    @IBOutlet weak var btPayment: UIButton!
    @IBOutlet weak var lbTotalPaid: UILabel!
    @IBOutlet weak var lbIsInstallment: UILabel!
    @IBOutlet weak var lbLastExpireDate: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    
    var invoice: Invoice?
    var api: InvoiceAPI = InvoiceAPI.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? EditInvoiceViewController {
            vc.invoice = invoice!
            vc.delegate = self
        }
        if let vc = segue.destination as? PaymentViewController {
            vc.invoice = invoice!
            vc.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nonNilInvoice = invoice {
            lbTitle.text = invoice?.title
            lbDescription.text = nonNilInvoice.description!
            lbCategory.text = nonNilInvoice.type?.rawValue
            lbExpireDate.text = DateUtils.dateToString(nonNilInvoice.expireDate!, with: format)
            lbValue.text = "R$\(nonNilInvoice.value!)"
            lbInstallment.text = "1x"
            lbTotalPaid.text = "R$\(nonNilInvoice.totalPaid!)"
            lbIsInstallment.text = (nonNilInvoice.isInstallment!) ? "Sim" : "Não"
            lbLastExpireDate.text = DateUtils.dateToString(nonNilInvoice.lastExpireDate!, with: format)
        }
    }
    
    //MARK: - Actions
    @IBAction func editInvoice(_ sender: UIButton) {
        performSegue(withIdentifier: "editInvoiceSelected", sender: nil)
    }
    
    @IBAction func deleteInvoice(_ sender: UIButton) {
        api.deleteInvoice(invoice: invoice!) { (success, error) in
            if error == nil {
                self.doSnackbar("Invoice \(self.invoice!.title!) was deleted")
                self.navigationController?.popViewController(animated: true)
            } else {
                self.doSnackbar(error!)
            }
        }
    }
    
    @IBAction func makePayment(_ sender: UIButton) {
        performSegue(withIdentifier: "paymentSegue", sender: nil)
    }
    
    func doSnackbar(_ msg: String) {
        let message = MDCSnackbarMessage()
        message.text = msg
        MDCSnackbarManager.show(message)
    }
}
