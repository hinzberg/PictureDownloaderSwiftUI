//
//  GalleryPictureView.swift
//  Picture Downloader
//
//  Created by Holger Hinzberg on 24.11.21.
//

import SwiftUI

struct GalleryPictureView: View {
    
    @Binding var pictureSize: Double
    private var fileName: String
    private var fileURL:URL?
    
    init(item : FileDownloadItem, size : Binding<Double>) {
        self.fileURL =  URL(fileURLWithPath: item.localTargetFullPathWithFile)
        self.fileName = item.localTargetFilename
        self._pictureSize = size
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
                .frame(width: pictureSize, height: pictureSize)
                .cornerRadius(10)
            
            Text(fileName)
                .foregroundColor(.primary)
        }
        .frame(width: pictureSize + 50, height: pictureSize + 50, alignment: .center)
    }
}

struct GalleryPictureView_Previews: PreviewProvider {

    @State static var pictureSize: Double = 200
    static var previews: some View {
        GalleryPictureView(item: FileDownloadItem.Example() , size:  $pictureSize )
    }
}
