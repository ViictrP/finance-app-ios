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
    
    public class func dateToString(_ date: Date, with format: String) -> String {
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    public class func stringToDate(_ date: String, with format: String) -> Date? {
        formatter.dateFormat = format
        return formatter.date(from: date)
    }
}
