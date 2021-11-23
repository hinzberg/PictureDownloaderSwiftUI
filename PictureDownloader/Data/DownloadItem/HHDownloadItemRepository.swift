//  HHDownloadItemRepository.swift
//  PictureDownloader3
//  Created by Holger Hinzberg on 05.07.20.

import SwiftUI

public class HHDownloadItemRepository: ObservableObject {

    static let shared = HHDownloadItemRepository()
    
    private init() {
        updateItemsCountText()
    }

    private var sequentialNumber : Int = 1
   @AppStorage("appendSequentialNumber") var appendSequentialNumber = true
   @Published var items = [FileDownloadItem]()
   @Published var itemsCountText = ""

    func removeAll()
    {
        items.removeAll()
        self.updateItemsCountText()
   }
    
    func addItem(item : FileDownloadItem )
    {
        if self.appendSequentialNumber {
            item.localTargetFilename = "\(item.localTargetFilename) (\(self.sequentialNumber))"
            sequentialNumber = sequentialNumber + 1
        }
        else {
            self.createUnqiueFilename(checkItem: item)
        }
        
        items.append(item)
        self.updateItemsCountText()
   }
    
    func addItems(itemsArray : [FileDownloadItem] )
    {
        for item in itemsArray {
            self.addItem(item: item)
        }
   }
    
    func removeItem(item : FileDownloadItem )
    {
        items.removeAll { value in
            return value.id == item.id
        }
        self.updateItemsCountText()
   }
    
    private func createUnqiueFilename(checkItem : FileDownloadItem)
    {
        for item in self.items
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
        if self.items.count == 0 {
            self.itemsCountText = "Keine Bilder in der Warteschlange";
        } else if self.items.count > 1 {
            self.itemsCountText = "\(self.items.count) Bilder in der Warteschlage"
        } else {
        self.itemsCountText = "Ein Bild in der Warteschlage"
        }
    }
}
