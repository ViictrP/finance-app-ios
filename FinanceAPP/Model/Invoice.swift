//
//  Invoice.swift
//  FinanceAPP
//
//  Created by Victor Prado on 23/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import Foundation
import ObjectMapper

public enum InvoiceCategory: String {
    case homeExpenses = "Home expenses"
    case creditCard = "Credit card"
    case invoice = "Invoice"
}

public class Invoice: Mappable {
    
    fileprivate final let transformEnum = TransformOf<InvoiceCategory, String>(fromJSON: { (value: String?) -> InvoiceCategory? in
        if var convertedValue = value {
            convertedValue = convertedValue.lowercased().replacingOccurrences(of: "_", with: " ").capitalizingFirstLetter()
            return InvoiceCategory(rawValue: convertedValue)
        }
        return nil
    }, toJSON: { (value: InvoiceCategory?) -> String? in
        if let value = value {
            return value.rawValue
        }
        return nil
    })
    
    fileprivate final let transformDate = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
        if let value = value {
            return DateUtils.stringToDate(value, with: "yyyy-MM-dd HH:mm:ss")
        }
        return nil
    }, toJSON: { (value: Date?) -> String? in
        if let value = value {
            return DateUtils.dateToString(value, with: "yyyy-MM-dd HH:mm:ss")
        }
        return nil
    })
    
    var id: Int?
    var title: String?
    var value: Double?
    var expireDate: Date?
    var totalPaid: Double?
    var description: String?
    var type: InvoiceCategory?
    var isInstallment: Bool?
    var lastExpireDate: Date?
    var payment: Double?
    
    public init() {
        
    }
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        value <- map["value"]
        expireDate <- (map["expireDate"], transformDate)
        lastExpireDate <- (map["lastExpireDate"], transformDate)
        totalPaid <- map["totalPaid"]
        description <- map["description"]
        type <- (map["type"], transformEnum)
        isInstallment <- map["isInstallment"]
        payment <- map["payment"]
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

