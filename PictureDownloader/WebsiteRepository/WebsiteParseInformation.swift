//  WebsiteParseInformation.swift
//  Picture Downloader
//  Created by Holger Hinzberg on 24.05.21.

import Foundation

typealias StringTypeClosure = (String) -> String

class WebsiteParseInformation {
        
    // Find the right ParseInformation for a Website
    // if there is more than one
    var parseIdentification:String = ""
    
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


