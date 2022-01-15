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
                        .contextMenu {
                            Button("Show in Finder") { showInFinder(path: item.localTargetFullPathWithFile) }
                        }
                }
            }
        }.background(.background)
    }
    
    func showInFinder(path : String) {
        let url = URL(fileURLWithPath: path)
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
    
    struct GalleryView_Previews: PreviewProvider {
        static var previews: some View {
            GalleryView()
        }
    }
}
