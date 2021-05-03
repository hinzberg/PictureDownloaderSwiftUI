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
   @Published var items = [HHDownloadItem]()
   @Published var itemsCountText = ""

    func removeAll()
    {
        items.removeAll()
        self.updateItemsCountText()
   }
    
    func addItem(item : HHDownloadItem )
    {
        if self.appendSequentialNumber {
            item.imageTargetName = "\(item.imageTargetName) (\(self.sequentialNumber))"
            sequentialNumber = sequentialNumber + 1
        }
        else {
            self.createUnqiueFilename(checkItem: item)
        }
        
        items.append(item)
        self.updateItemsCountText()
   }
    
    func addItems(itemsArray : [HHDownloadItem] )
    {
        for item in itemsArray {
            self.addItem(item: item)
        }
   }
    
    func removeItem(item : HHDownloadItem )
    {
        items.removeAll { value in
            return value.id == item.id
        }
        self.updateItemsCountText()
   }
    
    private func createUnqiueFilename(checkItem : HHDownloadItem)
    {
        for item in self.items {
            // Same name but different sourceUrl
            if item.imageTargetName == checkItem.imageTargetName && item.imageSourceUrl != checkItem.imageSourceUrl
            {
                checkItem.imageTargetName = checkItem.imageTargetName + "_1"
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
