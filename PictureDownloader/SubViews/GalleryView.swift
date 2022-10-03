//  GalleryView.swift
//  Picture Downloader
//  Created by Holger Hinzberg on 23.11.21.

import SwiftUI
import WrappingHStack

struct GalleryView: View {
    
    @EnvironmentObject var downloadItemRepository : FileDownloadItemRepository
    @State private var pictureSize: Double = 200
    
    var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 250)),
    ]
    
    var body: some View {
        
        VStack {
            ScrollView {
                WrappingHStack(downloadItemRepository.itemsDownloaded, id: \.self ) { item in
                    GalleryPictureView(item: item , size: $pictureSize)
                        .contextMenu {
                            Button("Show in Finder") { showInFinder(path: item.localTargetFullPathWithFile) }
                        }
                }.padding()
            }
            Spacer()
            
            HStack {
                Spacer()
                Slider(value: $pictureSize , in: 100...500)
                    .frame(width: 300)
                Text("\(pictureSize, specifier: "%.0f")")
            }.padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 10))
                .background(.thinMaterial)
            
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
