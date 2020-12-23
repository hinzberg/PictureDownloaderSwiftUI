//  SettingsView.swift
//  PictureDownloader
//  Created by Holger Hinzberg on 19.11.20.

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("playSoundAtAdd") var playSoundAtAdd = false
    @AppStorage("playSoundAtFinish") var playSoundAtFinish = false
    @AppStorage("showNotifications") var showNotifications = false
    @AppStorage("imagepath") var imagePathString = ""
    
    var body: some View {
        
        VStack {
            HStack{
                Text("Save images at")
                Spacer()
            }
            
            HStack{
                TextField("Enter save path", text: $imagePathString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: self.pickFolder, label: {
                    Text("...")
                })
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
            HStack{
                Toggle("Play sound when new pictures have been added", isOn: $playSoundAtAdd)
                Spacer()
            }
            HStack{
                Toggle("Play sounds when all downlods are completed", isOn: $playSoundAtFinish)
                Spacer()
            }
            HStack{
                Toggle("Show notifications", isOn: $showNotifications)
                Spacer()
            }
            
            Spacer()
        }.padding()
    }
    
    func pickFolder() {
        let initDictectory = NSURL(fileURLWithPath: self.imagePathString)
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.canCreateDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.directoryURL = initDictectory as URL
        
        openPanel.begin{ (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue
            {
                //  The selected Folder
                let rootPath = openPanel.url!
                self.imagePathString = rootPath.path
                
                FileBookmarkHandler.shared.storeFolderInBookmark(url: openPanel.url!)
                FileBookmarkHandler.shared.saveBookmarksData()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
