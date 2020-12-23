//
//  WebsiteRepositoryItem.swift
//  PictureDownloaderSwift
//
//  Created by Holger Hinzberg on 14.06.14.
//  Copyright (c) 2014 Holger Hinzberg. All rights reserved.
//

import Foundation

typealias StringTypeClosure = (String) -> String

class WebsiteRepositoryItem
{
    // Text der auf der Galleryseite im HTML enthalten sein muss
    // um ein passendes Item zu erkennen.
    var identification:String = ""
    
    var startStrings = [String]()
    var endStrings = [String]()
    
    var filetypeString:String = ""
    var removeCharactersFromStart:Int = 0
    var addCharactersAtEnd:Int = 0
    
    // Teil der Einzelbild URL der dem Link vorrangestellt werden muss
    // weil er im Source der Seite nicht steht.
    var imageUrlAdditionalPrefix = ""

    var followupPageIdentifier = ""
    var followUpClosure:StringTypeClosure? = nil
}
