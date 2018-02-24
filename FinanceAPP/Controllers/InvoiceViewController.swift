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
    @IBOutlet weak var btEdit: UIButton!
    @IBOutlet weak var btDelete: UIButton!
    @IBOutlet weak var btPayment: UIButton!
    
    var invoice: Invoice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? EditInvoiceViewController {
            vc.invoice = invoice!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbTitle.text = invoice?.title
        lbCategory.text = invoice?.category.rawValue
        lbExpireDate.text = invoice?.expireDate
        lbValue.text = invoice?.value
        lbInstallment.text = invoice?.installment
    }
    
    //MARK: - Actions
    @IBAction func editInvoice(_ sender: UIButton) {
        performSegue(withIdentifier: "editInvoiceSelected", sender: nil)
    }
    
    @IBAction func deleteInvoice(_ sender: UIButton) {
    }
    
    @IBAction func makePayment(_ sender: UIButton) {
    }
    
}
