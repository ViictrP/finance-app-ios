//
//  NotificationsManager.swift
//  FinanceAPP
//
//  Created by Victor Prado on 15/03/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import Foundation
import UserNotifications

public class NotificationsManager {

    public static let shared: NotificationsManager = {
       let shared = NotificationsManager()
        return shared
    }()
    
    private init() {
        
    }
    
    public func scheduleNotification(identifier: String, _ title: String, subtitle: String, message: String, when date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = message
        // content.sound = UNNotificationSound(named: "sound_file_name.caf")
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "expire"
        let trigger = buildTrigger(date: date, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    private func buildTrigger(date: Date, repeats: Bool) -> UNCalendarNotificationTrigger {
        var dateComponents = NSCalendar.current.dateComponents([.day, .hour, .minute], from: Date())
        dateComponents.minute = dateComponents.minute! + 1
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
    }
}
