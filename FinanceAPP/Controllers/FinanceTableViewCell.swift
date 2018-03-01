//
//  FinanceTableViewCell.swift
//  FinanceAPP
//
//  Created by Victor Prado on 21/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit

class FinanceTableViewCell: UITableViewCell {

    @IBOutlet weak var invoiceTitle: UILabel!
    @IBOutlet weak var expireDate: UILabel!
    @IBOutlet weak var invoiceCategory: UILabel!
    @IBOutlet weak var invoiceValue: UILabel!
    @IBOutlet weak var invoiceInstallmentCount: UILabel!
    @IBOutlet weak var ivPaid: UIImageView!
    @IBOutlet weak var viPaidBg: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func prepare(invoice: Invoice) {
        invoiceTitle.text = invoice.title
        invoiceValue.text = "R$\(invoice.value!)"
        if let date = invoice.expireDate {
            expireDate.text = DateUtils.dateToString(date, with: "dd/MM")
        }
        invoiceInstallmentCount.text = "Test"
        if let type = invoice.type {
            invoiceCategory.text = type.rawValue
        }
        if let totalPaid = invoice.totalPaid, let value = invoice.value {
            if totalPaid >= value {
                ivPaid.isHidden = false
                viPaidBg.isHidden = false
            }
        }
        calculateInvoiceCount(expireDate: invoice.expireDate!, LastExpireDate: invoice.lastExpireDate!)
    }

    func calculateInvoiceCount(expireDate: Date, LastExpireDate: Date) {
        let form = DateComponentsFormatter()
        form.maximumUnitCount = 2
        form.unitsStyle = .full
        form.allowedUnits = [.month]
        let s = form.string(from: expireDate, to: LastExpireDate)
        invoiceInstallmentCount.text = s!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
}
