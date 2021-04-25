//  PictureDownloaderController.swift
//  PictureDownloader
//  Created by Holger Hinzberg on 19.11.20.

import SwiftUI

public class PictureDownloaderController : HHGalleryAnalyserDelegateProtocol, HHFileDownloaderDelegateProtocol, ObservableObject  {
    
    var downloadItemRepository = HHDownloadItemRepository.shared;
    var lastPasteboardUrl : String = ""
    var urlGetter = PasteboardUrlGetter()
    var galleryAnalyser = HHGalleryAnalyser()
    var fileDownloader = HHFileDownloader()
    var timer : Timer?
    @Published var activeItemName = ""
    
    @AppStorage("playSoundAtFinish") var playSoundAtFinish = false
    @AppStorage("showNotifications") var showNotifications = false
    
    init() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        self.galleryAnalyser.delegate = self
        
        // Assign Delegate
        self.fileDownloader.delegate = self
        // Assign folder to save pictures
        self.fileDownloader.downloadFolder = self.checkOrCreateSaveFolder()
    }
    
    private func checkOrCreateSaveFolder() -> (String)
    {
        var folder:String = ""
        
        let imagePath = "imagepath"
        let defaults = UserDefaults.standard
        let data:AnyObject? = defaults.object(forKey: imagePath) as AnyObject
        if data != nil && data is String
        {
            folder = data as! String
        }
        else
        {
            folder = NSHomeDirectory()
            folder += "Desktop/Babes"
        }
        
        let fileHelper = HHFileHelper()
        var _ = fileHelper.checkIfFolderDoesExists(folder: folder, doCreate: true)
        
        return folder
    }
    
    @objc func timerTick() {
   
        var currentPasteboardUrl = ""
       
        // For Debug
         currentPasteboardUrl = "https://www.hqbabes.com/Bexie+Williams+-+All-around+Ravishing-406169/?t=p3"
        //currentPasteboardUrl = "https://vi.hentai-cosplay.com/image/nonsummerjack-non-my-god-anubis/"
        //currentPasteboardUrl = "https://vi.hentai-cosplays.com/image/qqueen-bremerton-2/"
        // currentPasteboardUrl = "https://www.elitebabes.com/super-sweet-blue-eyed-doll-erotically-poses-her-nubile-body-by-the-window-46313/"
        
        // Get the current Url from the pasteboard
        if currentPasteboardUrl == ""
        {
            currentPasteboardUrl = self.urlGetter.getPastboardUrl()
        }
        
        // Url not empty an different the the last pasteboard entry?
        if !currentPasteboardUrl.isEmpty && currentPasteboardUrl != lastPasteboardUrl
        {
            self.lastPasteboardUrl = currentPasteboardUrl
            self.galleryAnalyser.analyseGallery(urlString: currentPasteboardUrl)
        }
    }
    
    // MARK:- GalleryAnalyserDelegate-Methods
    
    func galleryAnalysingCompleted(downloadItemsArray: [HHDownloadItem]) {
        self.downloadItemRepository.addItems(itemsArray: downloadItemsArray)
        self.showBadgeCount()
    }
    
    func galleryAnalyserStatusMessage(message: String) {
    }
  
    private func showBadgeCount()
    {
        let itemsCount = self.downloadItemRepository.items.count;
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
        let item = self.downloadItemRepository.items.first
        if let downloadItem = item
        {
            LogItemRepository.shared.addItem(item: LogItem(message: "Loading \(downloadItem.imageUrl)"))
            // Statustext
            self.activeItemName = downloadItem.imageName
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
    
    func downloadItemAsyncCompleted(item: HHDownloadItem) {
        
        downloadItemRepository.removeItem(item: item)
        
        if downloadItemRepository.items.count > 0 {
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
    
    func downloadError(message: String) {
        LogItemRepository.shared.addItem(item: LogItem(message: message, priority: .Exclamation))
    }
}
