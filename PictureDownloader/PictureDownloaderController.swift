//  PictureDownloaderController.swift
//  PictureDownloader
//  Created by Holger Hinzberg on 19.11.20.

import SwiftUI
import Hinzberg_Foundation
import AudioToolbox

public class PictureDownloaderController : WebsiteGalleryAnalyserDelegateProtocol, FileDownloaderDelegateProtocol, ObservableObject
{
    // @Published var activeItemName = ""
    
    private var downloadItemRepository = FileDownloadItemRepository.shared;
    private var lastPasteboardUrl : String = ""
    private var urlGetter = PasteboardUrlGetter()
    private var galleryAnalyser = WebsiteGalleryAnalyser()
    private var fileDownloader = FileDownloader()
    private var timer : Timer?
    
    
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
            self.downloadItemRepository.activeItemName = "\(downloadItem.localTargetFilename)\(downloadItem.localTargetFileExtension)"
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
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_UserPreferredAlert))
            }
            
            LogItemRepository.shared.addItem(item: LogItem(message: "Downloads completed"))
            if self.showNotifications {
                HHNotificationCenter.shared.addSimpleAlarmNotification(title: "Done!", body: "Downloads completed")
            }
            self.downloadItemRepository.activeItemName = ""
        }
    }
    
    func downloadError(item:FileDownloadItem, message:String) {
        LogItemRepository.shared.addItem(item: LogItem(message: message, priority: .Exclamation))
        self.downloadItemAsyncCompleted(item: item)
    }
}
