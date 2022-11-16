//  NavigationManagerView.swift
//  PictureDownloader
//  Created by Holger Hinzberg on 16.11.22.

import SwiftUI

struct NavigationManagerView: View {
    
    var sideBarItems : [NavigationSideBarItem]
    init()
    {
        sideBarItems =  [
            NavigationSideBarItem(displayText: "Download Que", imageName: "list.dash", identifier: .downloadQue)
            ,NavigationSideBarItem(displayText: "Gallery", imageName: "square.grid.2x2", identifier: .gallery)
            ,NavigationSideBarItem(displayText: "Logs", imageName: "text.bubble", identifier: .logs)
            ,NavigationSideBarItem(displayText: "Settings", imageName: "gear", identifier: .settings)
        ]
    }
    
    @State var sideBarVisibility : NavigationSplitViewVisibility = .doubleColumn
    @State var selectedIdentifier : NavigationSideBarItemIdentifier = .downloadQue
    
    var body: some View {
        NavigationSplitView(columnVisibility: $sideBarVisibility) {
            List(sideBarItems, selection: $selectedIdentifier) { item in
                NavigationLink (value:  item.identifier) {
                    Label("\(item.displayText)", systemImage: item.imageName)
                }
            }
        } detail: {
            switch selectedIdentifier {
            case .downloadQue:
                DownloadQueView()
            case .gallery:
                GalleryView()
            case .logs:
                LogItemListView() 
            case .settings:
                SettingsView()
            }
        }
    }
}

struct NavigationManagerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationManagerView()
    }
}
