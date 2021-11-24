//  GalleryView.swift
//  Picture Downloader
//  Created by Holger Hinzberg on 23.11.21.

import SwiftUI

struct GalleryView: View {

    @EnvironmentObject var downloadItemRepository : HHDownloadItemRepository
    
    var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 250)),
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: self.columns, alignment: .center, spacing: 10)  {
                ForEach(downloadItemRepository.itemsDownloaded, id: \.id) {item in
                    GalleryPictureView(item: item)
                }
            }
        }.background(.background)
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}
