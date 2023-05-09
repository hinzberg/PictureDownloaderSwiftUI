//  PictureDownloaderController.swift
//  PictureDownloader
//  Created by Holger Hinzberg on 19.11.20.

import SwiftUI
import Hinzberg_Foundation

public class PictureDownloaderController : WebsiteGalleryAnalyserDelegateProtocol, FileDownloaderDelegateProtocol, ObservableObject
{
    var downloadItemRepository = FileDownloadItemRepository.shared;
    var lastPasteboardUrl : String = ""
    var urlGetter = PasteboardUrlGetter()
    var galleryAnalyser = WebsiteGalleryAnalyser()
    var fileDownloader = FileDownloader()
    var timer : Timer?
    @Published var activeItemName = ""
        
    @AppStorage("playSoundAtFinish") var playSoundAtFinish = false
    @AppStorage("showNotifications") var showNotifications = false
    @AppStorage("downloadFolder") var downloadFolder = ""
    
    init() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)

        self.galleryAnalyser.delegate = self
        
        // Assign Delegate
        self.fileDownloader.delegate = self
       
        // Assign folder to save pictures
       self.checkOrCreateSaveFolder()
        
        // updateItemsCountText()
    }
        
    private func checkOrCreateSaveFolder()
    {
        if self.downloadFolder.isEmpty
        {
            var folder:String = NSHomeDirectory()
            folder += "Desktop/PictureDownloader"
            self.downloadFolder = folder
        }

        let fileHelper = HHFileHelper()
        var _ = fileHelper.checkIfFolderDoesExists(folder: self.downloadFolder, doCreate: true)
    }
    
    @objc func timerTick() {
        
        var currentPasteboardUrl = ""
        // For Debug
        // currentPasteboardUrl = "https://babesource.com/galleries/chantal-danielle-big-tit-cream-pie-138399.html"
        // currentPasteboardUrl = "https://cosplaythots.com/p/69034"
        //currentPasteboardUrl = "https://babesource.com/galleries/blake-blossom-brazzers-exxtra-97140.html"
        // currentPasteboardUrl = "https://www.hqbabes.com/Bexie+Williams+-+All-around+Ravishing-406169/?t=p3"
        //currentPasteboardUrl = "https://vi.hentai-cosplay.com/image/nonsummerjack-non-my-god-anubis/"
        //currentPasteboardUrl = "https://vi.hentai-cosplays.com/image/qqueen-bremerton-2/"
        // currentPasteboardUrl = "https://www.elitebabes.com/super-sweet-blue-eyed-doll-erotically-poses-her-nubile-body-by-the-window-46313/"
        // currentPasteboardUrl = "https://www.elitebabes.com/huge-round-tits-with-large-pink-areolas-and-sexy-slim-waist-are-the-best-sexual-assets-of-sexy-maria/"
        // currentPasteboardUrl = "https://www.erocurves.com/bunny-colby-in-tight-shorts/"
        // currentPasteboardUrl = "https://www.erocurves.com/kate-england-puffy-nipples/"
        // currentPasteboardUrl = "https://www.pornpics.de/galleries/teenage-interviewer-blake-blossom-gives-a-boobjob-to-a-potential-employee-99737934/"
        // currentPasteboardUrl = "https://drommgirls.com/evelyn-beauty-on-top/"
        // currentPasteboardUrl = "http://xnutofuud.com/?p=519"
        
        // Get the current Url from the pasteboard
        if currentPasteboardUrl == ""  {
            currentPasteboardUrl = self.urlGetter.getPastboardUrl()
        }
        
        // Url not empty and different than the last pasteboard entry?
        if !currentPasteboardUrl.isEmpty && currentPasteboardUrl != lastPasteboardUrl
        {
            self.lastPasteboardUrl = currentPasteboardUrl
            self.galleryAnalyser.analyseGallery(urlString: currentPasteboardUrl)
        }
    }
    
    // MARK:- GalleryAnalyserDelegate-Methods
        
    func galleryAnalysingCompleted(downloadItemsArray: [FileDownloadItem])
    {
        self.downloadItemRepository.addMany(items: downloadItemsArray)
        self.showBadgeCount()
    }
    
    func galleryAnalyserStatusMessage(message: String) {
    }
  
    private func showBadgeCount()
    {
        let itemsCount = self.downloadItemRepository.itemsToDownload.count;
        if itemsCount > 0
        {
            let doc =  NSApp.dockTile as NSDockTile
            doc.badgeLabel = "\(itemsCount)"
        }
        else
        {
            let doc =  NSApp.dockTile as NSDockTile
            doc.badgeLabel = ""
        }
    }
    
    public func startDownloading() {
        self.downloadNextItem()
    }
    
    func downloadNextItem() -> ()
    {
        let item = self.downloadItemRepository.itemsToDownload.first
        if let downloadItem = item
        {
            LogItemRepository.shared.addItem(item: LogItem(message: "Loading \(downloadItem.webSourceUrl)"))
            // Statustext
            self.activeItemName = "\(downloadItem.localTargetFilename)\(downloadItem.localTargetFileExtension)"
            // Load item
            self.fileDownloader.downloadItemAsync(item: downloadItem)
        }
    }
    
    // MARK:- DownloaderDelegate-Methods
    
    func downloadWebpageHtmlAsyncCompleted(htmlSource: String) {
        // Unused
    }
    
    func downloadFileAsyncCompleted(fileLocation: String) {
        // Unused
    }
    
    func downloadItemAsyncCompleted(item: FileDownloadItem) {
        
        self.downloadItemRepository.moveItemToDownloaded(item: item)
        self.showBadgeCount()
        
        if downloadItemRepository.itemsToDownload.count > 0 {
            self.downloadNextItem()
        } else {
            if self.playSoundAtFinish {
                NSSound.beep()
            }
       
            LogItemRepository.shared.addItem(item: LogItem(message: "Downloads completed"))
            if self.showNotifications {
                HHNotificationCenter.shared.addSimpleAlarmNotification(title: "Done!", body: "Downloads completed")
            }
            self.activeItemName = ""
        }
    }
    
    func downloadError(item:FileDownloadItem, message:String) {
        LogItemRepository.shared.addItem(item: LogItem(message: message, priority: .Exclamation))
        self.downloadItemAsyncCompleted(item: item)
    }
    
    // ------------------------------------------------------------------------------
    /*
    private var sequentialNumber : Int = 1
    @AppStorage("appendSequentialNumber") var appendSequentialNumber = true
    
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
        
        itemsToDownload.append(item)
        self.updateItemsCountText()
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
    
    */
    
    
    
    
    
    
    
    
}
