//  DownloadQueView.swift
//  PictureDownloader
//  Created by Holger Hinzberg on 19.11.20.

import SwiftUI
import Hinzberg_SwiftUI

struct DownloadQueView: View , FileDownloadItemRowViewActionDelegateProtocol
{
    @EnvironmentObject var downloadItemRepository : FileDownloadItemRepository
    @State var showingRenameSheet = false
    
    var body: some View {
        VStack {
            VStack {
                List {
                    ForEach (self.downloadItemRepository.itemsToDownload, id: \.id) { item in
                        FileDownloadItemRowView(fileDownloadItem: item, delegate: self)
                    }.listRowInsets(EdgeInsets())
                }.listStyle(PlainListStyle())
                
                VStack{
                    Text("\(self.downloadItemRepository.itemsToDownloadCountText)")
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        Text("\(downloadItemRepository.activeItemName)")
            .padding(EdgeInsets(top: 2, leading: 2, bottom: 10, trailing: 2))
            .sheet(isPresented: $showingRenameSheet ) {
                showTextInputRenameSheet()
            }
    }
    
    func remove(fileDownloadItem: FileDownloadItem) {
        downloadItemRepository.remove(item: fileDownloadItem)
    }
    
    func edit(fileDownloadItem: FileDownloadItem) {
        downloadItemRepository.selectedViaDelegate = fileDownloadItem
        showingRenameSheet.toggle()
    }
    
    func removeItem(fileDownloadItem: FileDownloadItem) {
        downloadItemRepository.remove(item: fileDownloadItem)
    }
        
    func showTextInputRenameSheet() -> some View {
        return TextInputView(defaultText: downloadItemRepository.selectedViaDelegate?.localTargetFilename ?? "" ) { textContent in
            downloadItemRepository.selectedViaDelegate?.localTargetFilename = "\(textContent)"
        }
    }
}

struct DownloadQueView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadQueView()
    }
}
