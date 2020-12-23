//  HHDownloadItemRepository.swift
//  PictureDownloader3
//  Created by Holger Hinzberg on 05.07.20.

import Foundation

public class HHDownloadItemRepository: ObservableObject {

    static let shared = HHDownloadItemRepository()
    
    private init() {
        updateItemsCountText()
    }
    
   @Published var items = [HHDownloadItem]()
   @Published var itemsCountText = ""

    func removeAll()
    {
        items.removeAll()
        self.updateItemsCountText()
   }
    
    func addItem(item : HHDownloadItem )
    {
      items.append(item)
        self.updateItemsCountText()
   }
    
    func addItems(itemsArray : [HHDownloadItem] )
    {
        items.append(contentsOf: itemsArray)
        self.updateItemsCountText()
   }
    
    func removeItem(item : HHDownloadItem )
    {
        items.removeAll { value in
            return value.id == item.id
        }
        self.updateItemsCountText()
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
