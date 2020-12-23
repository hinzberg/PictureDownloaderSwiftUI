//  AppDelegate.swift
//  PictureDownloader
//  Created by Holger Hinzberg on 17.11.20.

import SwiftUI
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Notification Granted")
            } else {
                print("Notification not granted")
            }
        }
        FileBookmarkHandler.shared.loadBookmarks()
    }
}
