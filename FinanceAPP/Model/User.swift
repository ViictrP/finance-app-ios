//
//  User.swift
//  FinanceAPP
//
//  Created by Victor Prado on 02/03/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

public class User: Object, Mappable {
    public static var DISCARTABLE: Int = 84126382313434242
    
    @objc dynamic var id: Int = DISCARTABLE
    @objc dynamic var name: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var profile: String = ""
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    override public class func primaryKey() -> String? {
        return "id"
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        email <- map["email"]
        profile <- map["profile"]
    }
}
