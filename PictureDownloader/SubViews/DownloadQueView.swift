//  DownloadQueView.swift
//  PictureDownloader
//  Created by Holger Hinzberg on 19.11.20.

import SwiftUI

struct DownloadQueView: View {
    
    @ObservedObject var downloadItemRepository = HHDownloadItemRepository.shared;
    
    var body: some View {
        VStack {
            List {
                ForEach (self.downloadItemRepository.items, id: \.id) { item in
                    HHDownloadItemRowView(item: item)
          
                }
            }
            VStack{
                Text("\(self.downloadItemRepository.itemsCountText)")
            }
        }
    }
}

struct DownloadQueView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadQueView()
    }
}
