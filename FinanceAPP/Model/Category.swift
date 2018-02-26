//
//  Category.swift
//  FinanceAPP
//
//  Created by Victor Prado on 26/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import Foundation
import ObjectMapper

public class Category: Mappable {
 
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
    
    var id: Any?
    var title: String?
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        title <- (map["title"], transformEnum)
    }
}
