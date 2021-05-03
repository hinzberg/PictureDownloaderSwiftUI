//  HHGalleryAnalyser.swift
//  Picture Downloader
//  Created by Holger Hinzberg on 06.11.18.
//  Copyright © 2018 Holger Hinzberg. All rights reserved.

import SwiftUI
import UserNotifications

class HHGalleryAnalyser: NSObject
{
    private var htmlDownloader = HtmlDownloader();
    private var websiteRepo = WebsiteRepository()
    private var downloadItemsArray = [HHDownloadItem]()
    var delegate:HHGalleryAnalyserDelegateProtocol? // Delegate for Completion Handler
    
    @AppStorage("playSoundAtAdd") var playSoundAtAdd = false
    @AppStorage("showNotifications") var showNotifications = false
    
    override init()
    {
        super.init()
    }
    
    func analyseGallery(urlString:String)
    {
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
        
        let validation = self.htmlDownloader.validate(string: urlString)
        
        if  validation.isValid == true
        {
            self.htmlDownloader.downloadAsync(url: validation.url!) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                case.success(let html):
                    self.downloadHtmlCompleted(htmlSource: html)
                    break
                }
            }
        }
        else
        {
            let alert = NSAlert()
            alert.messageText = "Invalid Data"
            alert.informativeText = "\(urlString) \ncould not be validated."
            alert.runModal()

            LogItemRepository.shared.addItem(item: LogItem(message: "\(urlString) could not be validated.", priority: .Exclamation))
        }
    }
    
    internal func downloadHtmlCompleted(htmlSource: String)
    {
        // Html source of url was loaded
        if htmlSource.isEmpty
        {
            if self.showNotifications
            {
                HHNotificationCenter.shared.addSimpleAlarmNotification(title: "Error", body: "No valid HTML source could be found on loaded URL")
            }
            LogItemRepository.shared.addItem(item: LogItem(message: "No valid HTML source could be found on loaded URL", priority: .Exclamation))
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
                        HHNotificationCenter.shared.addSimpleAlarmNotification(title: "Images found!", body: "\(self.downloadItemsArray.count ) new downloads prepared")
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
            LogItemRepository.shared.addItem(item: LogItem(message:"No matching Repository Items found for Page", priority: .Warning))
        }
        else
        {
            // If there ist more than one match we just take the first match
            let item = items.first!
            LogItemRepository.shared.addItem(item: LogItem(message:"Matching Repository found \(item.identification)"))
            
            var imageDownloadLinkFound = false;
            let htmlParser = HtmlParser(item: item)
            let imageLinkArray = htmlParser.getImageArray(sourceParam: htmlSource)
            var htmlPageTitle = htmlParser.cutStringBetween(sourceParam: htmlSource, startString: "<title>", endString: "</title>")
            htmlPageTitle = htmlPageTitle.fixEncoding()
            htmlPageTitle = htmlPageTitle.removeInvalidFilenameCharacters()
            
            LogItemRepository.shared.addItem(item: LogItem(message:"Page title detected: \(htmlPageTitle)" ))
            
            if imageLinkArray.count > 0
            {
                createDownloadItems(pageTitle: htmlPageTitle, imageLinkArray: imageLinkArray)
                imageDownloadLinkFound = true
            }
            
            if item.followUpClosure != nil
            {
                linkToFollowupPage = htmlParser.getLinkToFollowupPage(sourceParam: htmlSource)
                if linkToFollowupPage != ""
                {
                    LogItemRepository.shared.addItem(item: LogItem(message:"Next page: \(linkToFollowupPage)" ))
                }
                else
                {
                    if let delegate = self.delegate
                    {
                        delegate.galleryAnalyserStatusMessage(message: "No more pages")
                    }
                }
            }
            
            if imageDownloadLinkFound == false
            {
                LogItemRepository.shared.addItem(item: LogItem(message:"No picture links found on this page.", priority: .Warning  ))
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
            downloadItem.imageSourceUrl = imageLink
            downloadItem.imageTargetName = "\(pageTitle) \(number)"
            downloadItem.imageTagetExtention = ".jpg"
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
