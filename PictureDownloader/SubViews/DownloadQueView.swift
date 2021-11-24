//  DownloadQueView.swift
//  PictureDownloader
//  Created by Holger Hinzberg on 19.11.20.

import SwiftUI


struct DownloadQueView: View {
    
    @EnvironmentObject var controller : PictureDownloaderController
    @EnvironmentObject var downloadItemRepository : HHDownloadItemRepository
    
    var body: some View {
        VStack {
            VStack {
                List {
                    ForEach (downloadItemRepository.itemsToDownload, id: \.id) { item in
                        HHDownloadItemRowView(item: item)
                    }
                }
                VStack{
                    Text("\(self.downloadItemRepository.itemsToDownloadCountText)")
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        Text("\(controller.activeItemName)")
            .padding(EdgeInsets(top: 2, leading: 2, bottom: 10, trailing: 2))
    }
}

struct DownloadQueView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadQueView()
    }
}
