//
//  SidebarView.swift
//  PictureDownloader
//
//  Created by Holger Hinzberg on 20.03.21.
//

import SwiftUI

struct SidebarView: View {
    
    @EnvironmentObject var controller : PictureDownloaderController
    @EnvironmentObject var downloadItemRepository : HHDownloadItemRepository
    
    var body: some View {
        List {
            NavigationLink(destination: DownloadQueView()) {
                Label("Download Que", systemImage: "list.dash")}
            
            NavigationLink(destination: GalleryView()) {
                Label("Gallery", systemImage: "square.grid.2x2")}
                        
            NavigationLink(destination: LogItemListView()    ) {
                Label("Logs", systemImage: "text.bubble")}
            
            NavigationLink(destination: SettingsView()) {
                Label("Settings", systemImage: "gear")}
            
        }.listStyle(SidebarListStyle())
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
