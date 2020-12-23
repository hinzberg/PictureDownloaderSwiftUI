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
    public var imageUrl:String = ""
    public var imageName:String = ""
    // Pfad und Dateinamen vom gespeicherten Bild
    public var saveImagePath = ""
    
    public static func Example() -> HHDownloadItem {
        let item = HHDownloadItem()
        item.imageName = "Bexie Williams - All-around Ravishing at HQ Babes 1"
        item.imageUrl = "https://c.xme.net/0c406169.jpg"
        return item
    }
    
    
}
