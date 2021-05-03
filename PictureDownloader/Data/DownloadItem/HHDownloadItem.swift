//
//  HHSDownloadItemEX.swift
//  URLSessionTest
//
//  Created by Holger Hinzberg on 13.08.17.
//  Copyright © 2017 Holger Hinzberg. All rights reserved.
//

import Foundation

public class HHDownloadItem: NSObject, Identifiable
{
    public var id = UUID()
    public var isActiveForDownload:Bool = true
    public var imageSourceUrl:String = ""
    
    public var imageTargetName:String = ""
    public var imageTagetExtention:String = ""
        
    // Pfad und Dateinamen vom gespeicherten Bild
    public var saveImagePath = ""
    
    public static func Example() -> HHDownloadItem {
        let item = HHDownloadItem()
        item.imageSourceUrl = "https://c.xme.net/0c406169.jpg"
        item.imageTargetName = "Bexie Williams - All-around Ravishing at HQ Babes 1"
        item.imageTagetExtention = ".jpf"
        return item
    }
}
