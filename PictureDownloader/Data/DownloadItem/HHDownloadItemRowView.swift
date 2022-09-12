//  HHDownloadItemRowView.swift
//  PictureDownloader3
//  Created by Holger Hinzberg on 05.07.20.

import SwiftUI

struct HHDownloadItemRowView: View {
    
    var item:FileDownloadItem
    
    var body: some View {
        VStack{
            Text("\(item.localTargetFilename)\(item.localTargetFileExtension)")
                .font(.headline).foregroundColor(Color.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("From: ")
                    .font(.body)
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
            
        }.padding(5)
    }
}

struct HHDownloadItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        HHDownloadItemRowView(item: FileDownloadItem.Example())
    }
}
