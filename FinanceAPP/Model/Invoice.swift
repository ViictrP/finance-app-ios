//
//  Invoice.swift
//  FinanceAPP
//
//  Created by Victor Prado on 23/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

public class Invoice: Object, Mappable {
    
    fileprivate final let transformDate = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
        if let value = value {
            return DateUtils.stringToDate(value)
        }
        return nil
    }, toJSON: { (value: Date?) -> String? in
        if let value = value {
            return DateUtils.dateToString(value)
        }
        return nil
    })
    
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var value: Double = 0.0
    @objc dynamic var expireDate: Date = Date()
    @objc dynamic var totalPaid: Double = 0.0
    @objc dynamic var invoiceDescription: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var categoryId: Int = 0
    @objc dynamic var isInstallment: Bool = false
    @objc dynamic var lastExpireDate: Date = Date()
    @objc dynamic var payment: Double = 0.0
    @objc dynamic var paid: Bool = false
    var category: Category?
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    override public class func primaryKey() -> String? {
        return "id"
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        value <- map["value"]
        expireDate <- (map["expireDate"], transformDate)
        lastExpireDate <- (map["lastExpireDate"], transformDate)
        totalPaid <- map["totalPaid"]
        invoiceDescription <- map["description"]
        isInstallment <- map["isInstallment"]
        payment <- map["payment"]
        paid <- map["paid"]
        category <- map["category"]
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

