//
//  GalleryPictureView.swift
//  Picture Downloader
//
//  Created by Holger Hinzberg on 24.11.21.
//

import SwiftUI

struct GalleryPictureView: View {
    
    public var fileName: String
    public var fileURL:URL?
    
    init(item : FileDownloadItem) {
        self.fileURL =  URL(fileURLWithPath: item.localTargetFullPathWithFile)
        self.fileName = item.localTargetFilename
    }
    
    var body: some View {
        VStack {
            
            AsyncImage(url: self.fileURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                } placeholder: {
                    Rectangle()
                        .fill(.thinMaterial)
                }
                .frame(width: 200, height: 200)
                .cornerRadius(10)
            
            Text(fileName)
                .foregroundColor(.primary)
        }
        .frame(width: 250, height: 250, alignment: .center)
    }
}

struct GalleryPictureView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryPictureView(item: FileDownloadItem.Example())
    }
}
