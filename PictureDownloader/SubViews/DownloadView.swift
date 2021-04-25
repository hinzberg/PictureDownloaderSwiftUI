//
//  DownloadView.swift
//  Picture Downloader
//
//  Created by Holger Hinzberg on 20.03.21.
//

import SwiftUI

struct DownloadView: View {
    
    @EnvironmentObject var controller : PictureDownloaderController
    
    var body: some View {
        VStack {
            DownloadQueView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Text("\(controller.activeItemName)")
                .padding(EdgeInsets(top: 2, leading: 2, bottom: 10, trailing: 2))
        }
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView()
    }
}
