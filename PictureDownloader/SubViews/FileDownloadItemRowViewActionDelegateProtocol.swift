//  FileDownloadItemRowViewActionDelegateProtocol.swift
//  Picture Downloader
//  Created by Holger Hinzberg on 09.05.23.

import Foundation

protocol FileDownloadItemRowViewActionDelegateProtocol {
    func remove(fileDownloadItem : FileDownloadItem)
    func edit(fileDownloadItem : FileDownloadItem)
}
