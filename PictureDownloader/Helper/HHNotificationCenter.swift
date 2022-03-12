//
//  HHNotificationCenter.swift
//  Picture Downloader
//
//  Created by Holger Hinzberg on 06.12.20.
//

import Cocoa
import UserNotifications

public class HHNotificationCenter {
    
    static let shared = HHNotificationCenter()
    
    private init() {  }
    
    func addSimpleAlarmNotification(title : String , body :String) {
        let notification = UNMutableNotificationContent()
        notification.title = title
        notification.body = body
        notification.categoryIdentifier = "Alarm"
        notification.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
}
