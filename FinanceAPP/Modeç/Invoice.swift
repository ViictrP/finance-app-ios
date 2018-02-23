//
//  Invoice.swift
//  FinanceAPP
//
//  Created by Victor Prado on 23/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import Foundation

public enum InvoiceCategory: String {
    case homeExpenses = "Home expenses"
    case creditCard = "Credit card"
    case invoice = "Invoice"
}

public class Invoice {
    
    var title: String
    var value: String
    var expireDate: String
    var installment: String
    var category: InvoiceCategory
    
    init(title: String, value: String, expireDate: String, installment: String, category: InvoiceCategory) {
        self.title = title
        self.value = value
        self.expireDate = expireDate
        self.installment = installment
        self.category = category
    }
}
