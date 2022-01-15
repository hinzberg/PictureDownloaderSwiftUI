//  HHDownloadItemRepository.swift
//  PictureDownloader3
//  Created by Holger Hinzberg on 05.07.20.

import SwiftUI

public class HHDownloadItemRepository: ObservableObject, IRepositoryProtocol {

    typealias T = FileDownloadItem
    static let shared = HHDownloadItemRepository()
    
    private init() {
        updateItemsCountText()
    }

    private var sequentialNumber : Int = 1
   @AppStorage("appendSequentialNumber") var appendSequentialNumber = true
   
    @Published var itemsDownloaded = [FileDownloadItem]()
    @Published var itemsDownloadedCountText = ""
    @Published var itemsToDownload = [FileDownloadItem]()
    @Published var itemsToDownloadCountText = ""
    
    func getItemCount() -> Int {
        return itemsToDownload.count
    }
    
    func removeAllItems() {
        itemsDownloaded.removeAll()
        itemsToDownload.removeAll()
        self.updateItemsCountText()
    }
    
    func addItem(item: FileDownloadItem)
    {
        if self.appendSequentialNumber {
            item.localTargetFilename = "\(item.localTargetFilename) (\(self.sequentialNumber))"
            sequentialNumber = sequentialNumber + 1
        }
        else {
            self.createUnqiueFilename(checkItem: item)
        }
        
        itemsToDownload.append(item)
        self.updateItemsCountText()
   }
    
    func addItems(itemsArray: [FileDownloadItem])
    {
        for item in itemsArray {
            self.addItem(item: item)
        }
   }
    
    func removeItem(item: FileDownloadItem)
    {
        itemsToDownload.removeAll { value in
            return value.id == item.id
        }
        self.updateItemsCountText()
   }
    
    func moveItemToDownloaded(item : FileDownloadItem )
    {
        let items = itemsToDownload.all(where: { $0.id == item.id })
        itemsDownloaded.append(contentsOf: items)
         
        itemsToDownload.removeAll { value in
            return value.id == item.id
        }
        self.updateItemsCountText()
   }
    
    private func createUnqiueFilename(checkItem : FileDownloadItem)
    {
        for item in self.itemsToDownload
        {
            // Same name but different sourceUrl
            if item.localTargetFilename == checkItem.localTargetFilename && item.webSourceUrl != checkItem.webSourceUrl
            {
                checkItem.localTargetFilename = checkItem.localTargetFilename + "_1"
                self.createUnqiueFilename(checkItem: checkItem)
            }
        }
    }

    private func updateItemsCountText() {
        
        self.itemsDownloadedCountText = "\(self.itemsDownloaded.count)"
        
        if self.itemsToDownload.count == 0 {
            self.itemsToDownloadCountText = "Keine Bilder in der Warteschlange";
        } else if self.itemsToDownload.count > 1 {
            self.itemsToDownloadCountText = "\(self.itemsToDownload.count) Bilder in der Warteschlage"
        } else {
        self.itemsToDownloadCountText = "Ein Bild in der Warteschlage"
        }
    }
}
