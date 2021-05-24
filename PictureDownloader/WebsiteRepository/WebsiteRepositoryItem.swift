//
//  WebsiteRepositoryItem.swift
//  PictureDownloaderSwift
//  Created by Holger Hinzberg on 14.06.14.
//  Copyright (c) 2014 Holger Hinzberg. All rights reserved.

import Foundation

class WebsiteRepositoryItem
{
    // Text der auf der Galleryseite im HTML enthalten sein muss
    // um ein passendes Item zu erkennen.
    var websiteIdentification:String = ""
    var websideParseInformation = [WebsiteParseInformation]()
}
