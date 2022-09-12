//  MainView.swift
//  PictureDownloader
//  Created by Holger Hinzberg on 19.11.20.

import SwiftUI

struct MainView: View {
    
    @ObservedObject var controller = PictureDownloaderController()
        
    var body: some View {
        
        NavigationView {
            List() {
                NavigationLink(destination: self.downloadView()) {
                    Label("Download Que", systemImage: "list.dash")}
                
                NavigationLink(destination: LogItemListView()    ) {
                    Label("Logs", systemImage: "text.bubble")}
                
                NavigationLink(destination: SettingsView()) {
                    Label("Settings", systemImage: "gear")}
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 200, idealWidth: 250, maxWidth: 300, maxHeight: .infinity)
            
            self.downloadView()
        }        
    }
    
    func downloadView () -> some View {
        VStack {
            DownloadQueView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Text("\(controller.activeItemName)")
                .padding(EdgeInsets(top: 2, leading: 2, bottom: 10, trailing: 2))
        }
    }
    
    func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
    func downloadAction () {
        self.controller.startDownloading()
    }
    
    func previewAction () {
    }
    
    func settingsAction () {
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
