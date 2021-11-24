//  PictureDownloaderApp.swift
//  PictureDownloader
//  Created by Holger Hinzberg on 17.11.20.

import SwiftUI

@main
struct PictureDownloaderApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var controller = PictureDownloaderController()
    @ObservedObject var downloadItemRepository = HHDownloadItemRepository.shared;
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SidebarView()
//                    .toolbar {
//                        ToolbarItem(placement: .navigation) {
//                            Button(action: {
//                                ToggleSidebar()
//                            }) { Image(systemName: "sidebar.left") }
//                        }
//                    }
                DownloadQueView()
            }
            .toolbar {
                
                ToolbarItem (placement: .navigation) {
                    Button(action: self.ToggleSidebar, label: {
                        Image(systemName: "sidebar.left").font(.headline)
                    })}
                                
                ToolbarItem (placement: .primaryAction) {
                    Button(action: self.downloadAction, label: {
                        Image(systemName: "square.and.arrow.down.fill").font(.headline)
                    })}
            }
            .environmentObject(controller)
            .environmentObject(downloadItemRepository)
        }
        //.windowToolbarStyle(UnifiedCompactWindowToolbarStyle())
        //.windowStyle(HiddenTitleBarWindowStyle())
    }
    
    func ToggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
    func downloadAction () {
        self.controller.startDownloading()
    }
}
