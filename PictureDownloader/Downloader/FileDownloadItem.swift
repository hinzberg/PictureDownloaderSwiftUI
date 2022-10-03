//  HHSDownloadItem.swift
//  Created by Holger Hinzberg
//  Copyright © 2017 Holger Hinzberg. All rights reserved.

import Foundation

public class FileDownloadItem: BaseRepositoryItem
{
    public var isActiveForDownload:Bool = true
    public var webSourceUrl:String = ""
    public var localTargetFolder:String = ""
    @Published var localTargetFilename:String = ""
    @Published var localTargetFileExtension:String = ""
    
    public var localTargetFullPathWithFile : String {
        return "\(self.localTargetFolder)/\(self.localTargetFilename)\(self.localTargetFileExtension)"
    }
    
    public static func Example() -> FileDownloadItem {
        let item = FileDownloadItem()
        item.webSourceUrl = "https://c.xme.net/0c406169.jpg"
        item.localTargetFilename = "Bexie Williams - All-around Ravishing at HQ Babes 1"
        item.localTargetFileExtension = ".jpf"
        return item
    }
}
