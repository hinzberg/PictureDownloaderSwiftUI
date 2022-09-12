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
                DownloadQueView()
            }
            .navigationTitle(getWindowTitle())
            .toolbar (id: "main") {
                ToolbarItem(id: "files", placement: .navigation) {
                    Button(action: self.ToggleSidebar) {
                        Label("Sidebar", systemImage: "sidebar.left")
                    }
                }
                ToolbarItem(id: "cleanup") {
                    Button(action: self.downloadAction) {
                            Label("Download", systemImage: "square.and.arrow.down.fill")
                    }
                }
            }
            .environmentObject(controller)
            .environmentObject(downloadItemRepository)
        }
        //.windowToolbarStyle(UnifiedCompactWindowToolbarStyle())
        //.windowStyle(HiddenTitleBarWindowStyle())
    }
    
    func getWindowTitle() -> String
    {
        return "Picture Downloader - Version \(Bundle.main.releaseVersionNumber)" 
    }
    
    
    func ToggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
    func downloadAction () {
        self.controller.startDownloading()
    }
}
