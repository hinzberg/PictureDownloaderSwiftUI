//  HHDownloadItemRepository.swift
//  PictureDownloader3
//  Created by Holger Hinzberg on 05.07.20.

import SwiftUI
import Hinzberg_Foundation

public class FileDownloadItemRepository: ObservableObject, RepositoryProtocol
{
    private var sequentialNumber : Int = 1
    @AppStorage("appendSequentialNumber") var appendSequentialNumber = true
    
    @Published var selectedViaDelegate : FileDownloadItem?
    @Published var activeItemName = ""
    
    var itemsDownloaded = [FileDownloadItem]() {
        willSet { /*self.objectWillChange.send()*/}
    }
    
    var itemsDownloadedCountText = "" {
        willSet { self.objectWillChange.send()}
    }
        
    var itemsToDownload = [FileDownloadItem]() {
        willSet { self.objectWillChange.send()}
    }
        
    var itemsToDownloadCountText = "" {
        willSet { self.objectWillChange.send()}
    }
    
    public typealias RepositoryType = FileDownloadItem
        
    public func getCount() -> Int {
        return itemsToDownload.count
    }
    
    public func add(item: FileDownloadItem)
    {
        if self.appendSequentialNumber {
            item.localTargetFilename = "\(item.localTargetFilename) (\(self.sequentialNumber))"
            sequentialNumber = sequentialNumber + 1
        }
        else {
            self.createUnqiueFilename(checkItem: item)
        }
        
        DispatchQueue.main.async {
            self.itemsToDownload.append(item)
            self.updateItemsCountText()
        }
    }
    
    public func addMany(items: [FileDownloadItem])
    {
        for item in items {
            self.add(item: item)
        }
    }
    
    public func remove(item: FileDownloadItem)
    {
        itemsToDownload.removeAll { value in
            return value.id == item.id
        }
        self.updateItemsCountText()
    }
    
    public func removeMany(items: [FileDownloadItem]) {
        return
    }
    
    public func getAll() -> [FileDownloadItem] {
        return itemsToDownload
    }
    
    public func getSelected() -> [FileDownloadItem] {
        let items = itemsToDownload.filter { $0.selected == true }
        return items
    }
    
    public func get(id: UUID) -> FileDownloadItem? {
        return nil
    }
    
    public func clear()
    {
        itemsDownloaded.removeAll()
        itemsToDownload.removeAll()
        self.updateItemsCountText()
    }
    
    static let shared = FileDownloadItemRepository()
    
    private init() {
        updateItemsCountText()
    }
        
    func removeAllItems() {
        itemsDownloaded.removeAll()
        itemsToDownload.removeAll()
        self.updateItemsCountText()
    }
    
    func moveItemToDownloaded(item : FileDownloadItem )
    {
        let items = itemsToDownload.allMatching(where: { $0.id == item.id })
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

    private func updateItemsCountText()
    {
        self.itemsDownloadedCountText = "\(self.itemsDownloaded.count)"
        
        if self.itemsToDownload.count == 0 {
            self.itemsToDownloadCountText = "No images in queue";
        } else if self.itemsToDownload.count > 1 {
            self.itemsToDownloadCountText = "\(self.itemsToDownload.count) images in queue"
        } else {
        self.itemsToDownloadCountText = "One image in queue"
        }
    }
}
