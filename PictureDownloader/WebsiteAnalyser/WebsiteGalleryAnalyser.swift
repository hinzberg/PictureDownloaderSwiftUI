//  HHGalleryAnalyser.swift
//  Picture Downloader
//  Created by Holger Hinzberg on 06.11.18.
//  Copyright © 2018 Holger Hinzberg. All rights reserved.

import SwiftUI
import UserNotifications
import AudioToolbox

class WebsiteGalleryAnalyser
{
    private var htmlDownloader = HtmlDownloader()
    private var websiteRepo = WebsiteRepository()
    private var downloadItemsArray = [FileDownloadItem]()
    private var htmlPageTitle : String = ""
    var delegate:WebsiteGalleryAnalyserDelegateProtocol? // Delegate for Completion Handler
    
    @AppStorage("playSoundAtAdd") var playSoundAtAdd = false
    @AppStorage("showNotifications") var showNotifications = false
    @AppStorage("downloadFolder") var downloadFolder = ""
    
    func analyseGallery(urlString:String){
        self.downloadItemsArray.removeAll()
        self.validateAndPrepareDownload(urlString: urlString)
    }
    
    private func validateAndPrepareDownload(urlString:String) {
        
        // If it does nit start with http just ignore it
        if urlString.lowercased().starts(with: "http") == false {
            LogItemRepository.shared.addItem(item: LogItem(message: "\"\(urlString)\" was ignored. It may not be an URL", priority: .Information))
            return
        }
                
        if let delegate = self.delegate {
            LogItemRepository.shared.addItem(item: LogItem(message: "Analysing URL \(urlString)"))
            delegate.galleryAnalyserStatusMessage(message: urlString)
        }
        
        // Is this a valid URL?
        let validation = self.htmlDownloader.validate(string: urlString)
        
        if  validation.isValid == true {
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
        } else {
            let alert = NSAlert()
            alert.messageText = "Invalid Data"
            alert.informativeText = "\(urlString) \ncould not be validated."
            alert.runModal()
            
            LogItemRepository.shared.addItem(item: LogItem(message: "\(urlString) could not be validated.", priority: .Exclamation))
        }
    }
    
    // Delegate call from HTMLDownloader
    private func downloadHtmlCompleted(htmlSource: String) {
        if htmlSource.isEmpty {
            LogItemRepository.shared.addItem(item: LogItem(message: "No valid HTML source could be found on loaded URL", priority: .Exclamation))
            if self.showNotifications {
                HHNotificationCenter.shared.addSimpleAlarmNotification(title: "Error", body: "No valid HTML source could be found on loaded URL") }
        } else {
            let parserRepository = HTMLParserInstructionRepository()
            let parseInstruction = parserRepository.getMatchingParseInstruction(htmlSource: htmlSource)
            
            if parseInstruction == nil {
                LogItemRepository.shared.addItem(item: LogItem(message: "No matching Repository Items found for Page", priority: .Exclamation))
                if self.showNotifications {
                    HHNotificationCenter.shared.addSimpleAlarmNotification(title: "Error", body: "No matching Repository Items found for Page") }
            } else {
                LogItemRepository.shared.addItem(item: LogItem(message:"Matching Repository found \(parseInstruction!.name)"))
                
                let parser = HTMLParser()
                let result : HTMLParserResult = parser.Parse(instruction: parseInstruction!, htmlSource: htmlSource)
                self.createDownloadItems(result: result)
            }
        }
        
        if let delegate = self.delegate {
            delegate.galleryAnalysingCompleted(downloadItemsArray: self.downloadItemsArray) }
    }
    
    private func createDownloadItems( result : HTMLParserResult)
    {
        LogItemRepository.shared.addItem(item: LogItem(message: "\(result.Links.count) image links found"))
        
        if playSoundAtAdd {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_UserPreferredAlert))
        }
        
        for  imageLink in result.Links
        {
            let number = self.downloadItemsArray.count + 1;
            let downloadItem = FileDownloadItem()
            downloadItem.isActiveForDownload = true
            downloadItem.selected = false
            downloadItem.webSourceUrl = imageLink
            downloadItem.localTargetFilename = "\(result.Title) \(number)"
            downloadItem.localTargetFileExtension = ".jpg"
            downloadItem.localTargetFolder = self.downloadFolder
            downloadItemsArray.append(downloadItem)
            LogItemRepository.shared.addItem(item: LogItem(message: "Image link added \(imageLink)"))
        }
    }
    
    func downloadFileAsyncCompleted(fileLocation: String)
    {
    }
    
    func downloadItemAsyncCompleted(item: FileDownloadItem)
    {
    }
    
    func downloadError(message: String)
    {
    }
}
