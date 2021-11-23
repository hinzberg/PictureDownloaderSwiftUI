//  FileDownloader.swift
//  Created by Holger Hinzberg
//  Copyright © 2021 Holger Hinzberg. All rights reserved.

import Foundation

class FileDownloader: NSObject, URLSessionDownloadDelegate
{
    var delegate:FileDownloaderDelegateProtocol? // Delegate for Completion Handler
    
    private var dataTask: URLSessionDataTask? // For HTTP Get, HTML Source
    private var downloadTask:URLSessionDownloadTask? // For file download

    private var downloadFilename = "";
    private var downloadItem:FileDownloadItem?
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Accept-Language": "en-US", "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.2 Safari/605.1.15" ];
        var session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()

    // MARK: File Download

    public func downloadItemAsync( item : FileDownloadItem)
    {
        self.downloadItem = item
        self.dataTask?.cancel()
        
        let url = NSURL(string: self.downloadItem!.webSourceUrl)
        if url != nil
        {
            // Start download
            downloadTask = downloadsSession.downloadTask(with: url! as URL)
            downloadTask?.resume()
        }
        else
        {
            // No Source URL -> Error!
            let urlText = self.downloadItem?.webSourceUrl ?? "Item nil"
            self.delegate?.downloadError(item: item, message: urlText)
        }
    }
    
    // Completion Handler from NSURLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        let success =  self.copyItemAtPath(srcPath: location.path, toPath: downloadItem!.localTargetFullPathWithFile)
        if success == true {
            LogItemRepository.shared.addItem(item: LogItem(message: "File saved \(downloadItem!.localTargetFullPathWithFile)"))
        }
        
        DispatchQueue.main.async() {
            self.delegate?.downloadItemAsyncCompleted(item: self.downloadItem!)
        }
    }
    
    // Copy file from temp folder to destionation folder
    private func copyItemAtPath(srcPath: String?, toPath dstPath: String?) -> Bool
    {
        var success = false
        
        if let sourcePath = srcPath, let destinationPath = dstPath
        {
            if FileManager.default.fileExists(atPath: destinationPath) {
                LogItemRepository.shared.addItem(item: LogItem(message: "Did not copy. File already exists \(dstPath ?? "Unknow Path")", priority: .Warning))
            } else {
                do
                {
                    try FileManager.default.copyItem(atPath: sourcePath, toPath: destinationPath)
                    success = true
                }
                catch let error as NSError
                {
                    LogItemRepository.shared.addItem(item: LogItem(message: "Could not copy \(dstPath ?? "Unknow Path") to disk: \(error.localizedDescription)", priority: .Exclamation ))
                }
            }
        }
        else
        {
            LogItemRepository.shared.addItem(item: LogItem(message: "Filepath could not be unwrapped. Possible NULL", priority: .Exclamation ))
        }
        
        return success
    }
}
