//  PictureDownloaderApp.swift
//  PictureDownloader
//  Created by Holger Hinzberg on 17.11.20.

import SwiftUI

@main
struct PictureDownloaderApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        
        WindowGroup {
            MainView()
        }
    }
}
