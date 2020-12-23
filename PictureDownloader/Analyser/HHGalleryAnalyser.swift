//  HHGalleryAnalyser.swift
//  Picture Downloader
//  Created by Holger Hinzberg on 06.11.18.
//  Copyright © 2018 Holger Hinzberg. All rights reserved.

import SwiftUI
import UserNotifications

class HHGalleryAnalyser: NSObject, HHFileDownloaderDelegateProtocol
{
    private var fileDownloader = HHFileDownloader()
    private var websiteRepo = WebsiteRepository()
    private var downloadItemsArray = [HHDownloadItem]()
    private var galleryTitle = ""
    var delegate:HHGalleryAnalyserDelegateProtocol? // Delegate for Completion Handler
    
    @AppStorage("playSoundAtAdd") var playSoundAtAdd = false
    @AppStorage("showNotifications") var showNotifications = false
    
    override init()
    {
        super.init()
        fileDownloader.delegate = self
    }
    
    func analyseGallery(urlString:String)
    {
        self.galleryTitle = ""
        self.downloadItemsArray.removeAll()
        self.validateAndPrepareDownload(urlString: urlString)
    }
    
    private func validateAndPrepareDownload(urlString:String)
    {
        if let delegate = self.delegate
        {
            LogItemRepository.shared.addItem(item: LogItem(message: urlString))
            delegate.galleryAnalyserStatusMessage(message: urlString)
        }
        
        let validation = self.fileDownloader.validate(string: urlString)
        if  validation.isValid == true
        {
            self.fileDownloader.downloadWebpageHtmlAsync(url: validation.url!)
        }
        else
        {
            let alert = NSAlert()
            alert.messageText = "Invalid Data"
            alert.informativeText = "\(urlString) \ncould not be validated."
            alert.runModal()
        }
    }
    
    internal func downloadWebpageHtmlAsyncCompleted(htmlSource: String)
    {
        // Html source of url was loaded
        if htmlSource.isEmpty
        {
            /*
             let alert = NSAlert()
             alert.messageText = "No HTML found"
             alert.informativeText = "No valid HTML source could be found on loaded URL"
             alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
             */
        }
        else
        {
            //self.htmlSource = htmlSource
            let linkToFollowupPage = self.analyseHtmlSource(htmlSource: htmlSource)
            // Any more pages?
            if linkToFollowupPage != ""
            {
                validateAndPrepareDownload(urlString: linkToFollowupPage)
            }
            else
            {
                // No more pages. We are done!
                if self.downloadItemsArray.count > 0
                {
                   
                    if self.playSoundAtAdd {
                        NSSound.beep()
                    }

                    // Show Notification
                    if self.showNotifications
                    {
                        HHNotificationCenter.shared.addSimpleAlarmNotification(title: self.galleryTitle, body: "\(self.downloadItemsArray.count ) new downloads prepared")
                    }
                    
                    LogItemRepository.shared.addItem(item: LogItem(message: "\(self.downloadItemsArray.count ) new downloads prepared"))
                    LogItemRepository.shared.addItem(item: LogItem(message: "Analysing Completed"))
                    
                    // Return all the items
                    if let delegate = self.delegate
                    {
                        delegate.galleryAnalysingCompleted(downloadItemsArray: self.downloadItemsArray)
                    }
                }
            }
        }
    }
    
    private func analyseHtmlSource(htmlSource:String) -> (String)
    {
        var linkToFollowupPage = ""
        let items:[WebsiteRepositoryItem] = self.websiteRepo.getItemForIdentification(ident: htmlSource)
        
        if items.count == 0
        {
           /*
             let alert = NSAlert()
             alert.messageText = "Missing Information"
             alert.informativeText = "No matching Repository Items found for Page"
             alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
          */
        }
        else
        {
            // If there are more than one match we take the first
            let item = items.first!
            // print("Matching Repository found \(item.identification)")
            
            var imageDownloadLinkFound = false;
            let htmlParser = HtmlParser(item: item)
            let imageLinkArray = htmlParser.getImageArray(sourceParam: htmlSource)
            var pageTitle = htmlParser.cutStringBetween(sourceParam: htmlSource, startString: "<title>", endString: "</title>")
            pageTitle = pageTitle.fixEncoding()
            
            LogItemRepository.shared.addItem(item: LogItem(message:"Page title detected: \(pageTitle)" ))
            
            // Title of the first page will be the title for the DownloadItems
            if self.galleryTitle == ""
            {
                self.galleryTitle = pageTitle
            }
            
            if imageLinkArray.count > 0
            {
                createDownloadItems(pageTitle: self.galleryTitle, imageLinkArray: imageLinkArray)
                imageDownloadLinkFound = true
            }
            
            if item.followUpClosure != nil
            {
                linkToFollowupPage = htmlParser.getLinkToFollowupPage(sourceParam: htmlSource)
                if linkToFollowupPage != ""
                {
                    print(linkToFollowupPage)
                }
                else
                {
                    if let delegate = self.delegate
                    {
                        delegate.galleryAnalyserStatusMessage(message: "Keine weiteren Seiten")
                    }
                }
            }
            
            if imageDownloadLinkFound == false
            {
                /*
                 let alert = NSAlert()
                 alert.messageText = "No pictures found!"
                 alert.informativeText = "No picture links found on this page."
                 alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
                 */
            }
        }
        
        return linkToFollowupPage
    }
    
    private func createDownloadItems(pageTitle:String, imageLinkArray:[String]) -> ()
    {
        LogItemRepository.shared.addItem(item: LogItem(message: "\(imageLinkArray.count) image links found"))
        for  imageLink in imageLinkArray
        {
            let number = self.downloadItemsArray.count + 1;
            let downloadItem = HHDownloadItem()
            downloadItem.isActiveForDownload = true
            downloadItem.imageUrl = imageLink
            downloadItem.imageName = "\(pageTitle) \(number).jpg"
            downloadItemsArray.append(downloadItem)
        }
    }
    
    func downloadFileAsyncCompleted(fileLocation: String)
    {
    }
    
    func downloadItemAsyncCompleted(item: HHDownloadItem)
    {
    }
    
    func downloadError(message: String)
    {
    }
}
