//
//  HHDownloadItemRowView.swift
//  PictureDownloader3
//
//  Created by Holger Hinzberg on 05.07.20.
//

import SwiftUI

struct HHDownloadItemRowView: View {
    
    var item:HHDownloadItem
    
    var body: some View {
        VStack{
            Text(item.imageName).font(.headline).foregroundColor(Color.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(item.imageUrl).font(.subheadline).foregroundColor(Color.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }.padding(5)
    }
}

struct HHDownloadItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        HHDownloadItemRowView(item: HHDownloadItem.Example())
    }
}
