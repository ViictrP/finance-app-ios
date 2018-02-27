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
 
    fileprivate final let transformEnum = TransformOf<String, String>(fromJSON: { (value: String?) -> String? in
        if var convertedValue = value {
            convertedValue = convertedValue.lowercased().replacingOccurrences(of: "_", with: " ").capitalizingFirstLetter()
            return convertedValue
        }
        return nil
    }, toJSON: { (value: String?) -> String? in
        if let value = value {
            return value
        }
        return nil
    })
    
    @objc dynamic var id: Int = DISCARTABLE
    @objc dynamic var title: String = ""
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        title <- (map["title"], transformEnum)
    }
}
