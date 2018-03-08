//
//  Category.swift
//  FinanceAPP
//
//  Created by Victor Prado on 26/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

public class Category: Object, Mappable {
    
    public static var DISCARTABLE: Int = 84126382313434242
    
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
    
    @objc dynamic var id: Int = DISCARTABLE
    @objc dynamic var title: String = ""
    @objc dynamic var invoicesCount: Int = 0
    @objc dynamic var createDate: Date = Date()
    @objc dynamic var updateDate: Date = Date()
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    override public class func primaryKey() -> String? {
        return "id"
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        invoicesCount <- map["invoicesCount"]
        createDate <- (map["createDate"], transformDate)
        updateDate <- (map["updateDate"], transformDate)
    }
}
