//  HHGalleryAnalyserDelegateProtocol.swift
//  Picture Downloader
//  Created by Holger Hinzberg on 06.11.18.
//  Copyright © 2018 Holger Hinzberg. All rights reserved.

import Foundation

protocol  HHGalleryAnalyserDelegateProtocol
{
    func galleryAnalysingCompleted(downloadItemsArray:[FileDownloadItem])
    func galleryAnalyserStatusMessage(message:String)
    
}
