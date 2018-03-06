//
//  DateUtils.swift
//  FinanceAPP
//
//  Created by Victor Prado on 26/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import Foundation

public class DateUtils {
        
    fileprivate static let formatter: DateFormatter = DateFormatter()
    
    
    
    private init() {
        
    }
    
    public class func dateToString(_ date: Date, format: String? = nil) -> String {
        if format != nil {
            formatter.dateFormat = format
        } else {
            formatter.dateFormat = "yyyy-MM-dd"
        }
        return formatter.string(from: date)
    }
    
    public class func stringToDate(_ date: String, format: String? = nil) -> Date? {
        if format != nil {
            formatter.dateFormat = format
        } else {
            formatter.dateFormat = "yyyy-MM-dd"
        }
        return formatter.date(from: date)
    }
}
