//  HHSFileDownloaderEX.swift
//  URLSessionTest
//  Created by Holger Hinzberg on 13.08.17.
//  Copyright © 2017 Holger Hinzberg. All rights reserved.

import Foundation

class HHFileDownloader: NSObject, URLSessionDownloadDelegate
{
    var delegate:HHFileDownloaderDelegateProtocol? // Delegate for Completion Handler
    
    private var dataTask: URLSessionDataTask? // For HTTP Get, HTML Source
    private var downloadTask:URLSessionDownloadTask? // For file download

    var downloadFolder = ""
    private var downloadFilename = "";
    private var downloadItem:HHDownloadItem?
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Accept-Language": "en-US", "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.2 Safari/605.1.15" ];
        var session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()

    // MARK: File Download
    
    public func downloadFileAsync(url:URL , downloadFolder:String , downloadFilename:String)
    {
        self.downloadFolder = downloadFolder
        self.downloadFilename = downloadFilename
        
        self.dataTask?.cancel()
        self.downloadItem = nil
        self.downloadTask = downloadsSession.downloadTask(with: url)
        self.downloadTask?.resume()
    }
    
    public func downloadItemAsync( item : HHDownloadItem)
    {
        self.downloadItem = item
        self.dataTask?.cancel()
        
        let url = NSURL(string: self.downloadItem!.imageSourceUrl)
        if url != nil
        {
            downloadTask = downloadsSession.downloadTask(with: url! as URL)
            downloadTask?.resume()
        }
        else
        {
            let urlText = self.downloadItem?.imageSourceUrl ?? "Item nil"
            self.delegate?.downloadError(item: item, message: urlText)
        }
    }
    
    // Completion Handler from NSURLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        //  Download via filename
        if  self.downloadItem == nil
        {
            var fileLocation =  self.downloadFolder
            if self.downloadFolder.last != "/"
            {
                fileLocation += "/"
            }
            fileLocation += self.downloadFilename
            
            let success =  self.copyItemAtPath(srcPath: location.path, toPath: fileLocation)
            if success == true {
                LogItemRepository.shared.addItem(item: LogItem(message: "Image saved \(fileLocation)"))
            }
            
            DispatchQueue.main.async()
            {
                self.delegate?.downloadFileAsyncCompleted(fileLocation: fileLocation)
            }
        }
        else
        {
            // Download via DownloadItem
            let targetUrlText = "\(self.downloadFolder)/\(self.downloadItem!.imageTargetName)\(self.downloadItem!.imageTagetExtention)"
            self.downloadItem?.saveImagePath = targetUrlText
            
            let success =  self.copyItemAtPath(srcPath: location.path, toPath: targetUrlText)
            if success == true {
                LogItemRepository.shared.addItem(item: LogItem(message: "Image saved \(targetUrlText)"))
            }
            
            DispatchQueue.main.async()
            {
                self.delegate?.downloadItemAsyncCompleted(item: self.downloadItem!)
            }
        }
    }
    
    func copyItemAtPath(srcPath: String?, toPath dstPath: String?) -> Bool
    {
        var success = true
        
        if let sourcePath = srcPath, let destinationPath = dstPath
        {
            let fileManager = FileManager.default
            do
            {
                try fileManager.copyItem(atPath: sourcePath, toPath: destinationPath)
            }
            catch let error as NSError
            {
                LogItemRepository.shared.addItem(item: LogItem(message: "Could not copy \(dstPath ?? "Unknow Path") to disk: \(error.localizedDescription)", priority: .Exclamation ))
                success = false
            }
        }
        else
        {
            LogItemRepository.shared.addItem(item: LogItem(message: "Filepath could not be unwrapped. Possible NULL", priority: .Exclamation ))
            success = false
        }
        return success
    }
    

}
