//  HHDownloadItemRowView.swift
//  PictureDownloader3
//  Created by Holger Hinzberg on 05.07.20.

import SwiftUI

struct FileDownloadItemRowView: View {
    
    @ObservedObject var item:FileDownloadItem
    
    var body: some View {
        VStack{
            Text("\(item.localTargetFilename)\(item.localTargetFileExtension)")
                .font(.title2).foregroundColor(Color.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("From: ")
                    .foregroundColor(Color.secondary)
                    .frame(width: 40, alignment: .leading)
                Text(item.webSourceUrl)
                    .font(.body)
                    .foregroundColor(Color.secondary)
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("To: ")
                    .font(.body)
                    .foregroundColor(Color.secondary)
                    .frame(width: 40, alignment: .leading)
                Text(item.localTargetFullPathWithFile)
                    .font(.body)
                    .foregroundColor(Color.secondary)
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .background(item.selected ? Color.accentColor.opacity(0.1) : Color(NSColor.controlBackgroundColor) )
        .onTapGesture {
            item.selected.toggle()
        }
    }
}

struct HHDownloadItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        FileDownloadItemRowView(item: FileDownloadItem.Example())
    }
}
