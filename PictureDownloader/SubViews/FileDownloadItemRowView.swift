//  HHDownloadItemRowView.swift
//  PictureDownloader3
//  Created by Holger Hinzberg on 05.07.20.

import SwiftUI

struct FileDownloadItemRowView: View {
    
    @ObservedObject var fileDownloadItem:FileDownloadItem
    
    var body: some View {
        VStack{
            Text("\(fileDownloadItem.localTargetFilename)\(fileDownloadItem.localTargetFileExtension)")
                .font(.title2).foregroundColor(Color.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("From: ")
                    .foregroundColor(Color.secondary)
                    .frame(width: 40, alignment: .leading)
                Text(fileDownloadItem.webSourceUrl)
                    .font(.body)
                    .foregroundColor(Color.secondary)
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("To: ")
                    .font(.body)
                    .foregroundColor(Color.secondary)
                    .frame(width: 40, alignment: .leading)
                Text(fileDownloadItem.localTargetFullPathWithFile)
                    .font(.body)
                    .foregroundColor(Color.secondary)
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .background(fileDownloadItem.selected ? Color.accentColor.opacity(0.1) : Color(NSColor.controlBackgroundColor) )
        .onTapGesture {
            fileDownloadItem.selected.toggle()
        }
    }
}

struct HHDownloadItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        FileDownloadItemRowView(fileDownloadItem: FileDownloadItem.Example())
    }
}
