//  PictureDownloaderApp.swift
//  PictureDownloader
//  Created by Holger Hinzberg on 17.11.20.

import SwiftUI
import Hinzberg_SwiftUI

@main
struct PictureDownloaderApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var controller = PictureDownloaderController()
    @ObservedObject var downloadItemRepository = FileDownloadItemRepository.shared;
    @State var showingRenameSheet = false
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SidebarView()
                DownloadQueView()
            }
            .sheet(isPresented: $showingRenameSheet ) {
                showTextInputRenameSheet()
            }
            
            .navigationTitle(getWindowTitle())
            .toolbar (id: "main") {
                ToolbarItem(id: "files", placement: .navigation) {
                    Button(action: self.ToggleSidebar) {
                        Label("Sidebar", systemImage: "sidebar.left")
                    }
                }
                
                ToolbarItem(id: "rename") {
                    Button(action: self.renameAction) {
                        Label("Rename", systemImage: "text.quote")
                    }
                }
                
                ToolbarItem(id: "selectall") {
                    Button(action: self.selectAllAction) {
                        Label("Select all", systemImage: "plus.square")
                    }
                }
                
                ToolbarItem(id: "download") {
                    Button(action: self.downloadAction) {
                        Label("Download", systemImage: "arrow.down.app.fill")
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
    
    func renameAction () {
        let items = downloadItemRepository.getSelected()
        if items.count == 0 {
            return
        }
        showingRenameSheet.toggle()
    }
    
    func selectAllAction() {
        let items = downloadItemRepository.getAll()
        for item in items {
            item.selected = true
        }
    }
    
    func showTextInputRenameSheet() -> some View {
        return TextInputView(defaultText: downloadItemRepository.getSelected().first?.localTargetFilename ?? "" ) { textContent in
            var index = 1;
            let items = downloadItemRepository.getSelected()
            for item in items {
                item.localTargetFilename = "\(textContent) \(index)"
                index = index + 1
            }
        }
    }
}

