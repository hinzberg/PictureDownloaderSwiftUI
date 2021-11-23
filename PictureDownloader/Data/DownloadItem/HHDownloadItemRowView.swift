//  HHDownloadItemRowView.swift
//  PictureDownloader3
//  Created by Holger Hinzberg on 05.07.20.

import SwiftUI

struct HHDownloadItemRowView: View {
    
    var item:FileDownloadItem
    
    var body: some View {
        VStack{
            //Text("\(item.localTargetFilename)").font(.largeTitle)
            
            Text("\(item.localTargetFilename)\(item.localTargetFileExtension)").font(.headline).foregroundColor(Color.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(item.webSourceUrl).font(.subheadline).foregroundColor(Color.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }.padding(5)
    }
}

struct HHDownloadItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        HHDownloadItemRowView(item: FileDownloadItem.Example())
    }
}
