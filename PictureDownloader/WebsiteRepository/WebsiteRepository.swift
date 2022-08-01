//  WebsiteRepository.swift
//  PictureDownloaderSwift
//  Created by Holger Hinzberg on 14.06.14.
//  Copyright (c) 2014 Holger Hinzberg. All rights reserved.

import Foundation

class WebsiteRepository
{
    var websites = [WebsiteRepositoryItem]()
    
    init()
    {
        var item = WebsiteRepositoryItem()
        item.websiteIdentification = "https://www.erocurves.com/";
        var ident = WebsiteParseInformation()
        ident.parseIdentification = "<a href=\'https://cdn.erocurves.com/wp-content/uploads/"
        ident.startStrings.append("<a href=\'https://cdn.erocurves.com/wp-content/uploads/")
        ident.endStrings.append(".jpg")
        ident.filetypeString = ".jpg"
        ident.removeCharactersFromStart = 9
        ident.addCharactersAtEnd = 4
        item.websideParseInformation.append(ident)
            
        ident = WebsiteParseInformation()
        ident.parseIdentification = "<a href=\'https://cdn.erocurves.com/galleries/"
        ident.startStrings.append("<a href=\'https://cdn.erocurves.com/galleries/")
        ident.endStrings.append(".jpg")
        ident.filetypeString = ".jpg"
        ident.removeCharactersFromStart = 9
        ident.addCharactersAtEnd = 4
        item.websideParseInformation.append(ident)
        websites.append(item)
                
        item = WebsiteRepositoryItem()
        item.websiteIdentification = "https://www.elitebabes.com";
        ident = WebsiteParseInformation()
        ident.startStrings.append("href=\"https://k5x5n5g8.ssl.hwcdn.net/content")
        ident.endStrings.append(".jpg")
        ident.filetypeString = ".jpg"
        ident.removeCharactersFromStart = 6
        ident.addCharactersAtEnd = 4
        item.websideParseInformation.append(ident)
        websites.append(item)
        
        item = WebsiteRepositoryItem()
        item.websiteIdentification = "www.pornpics.de";
        ident = WebsiteParseInformation()
        ident.startStrings.append("href='https://cdni.pornpics.de/")
        ident.endStrings.append(".jpg")
        ident.filetypeString = ".jpg"
        ident.removeCharactersFromStart = 6
        ident.addCharactersAtEnd = 4
        item.websideParseInformation.append(ident)
        websites.append(item)
        
        item = WebsiteRepositoryItem()
        item.websiteIdentification = "drommgirls.com";
        ident = WebsiteParseInformation()
        ident.startStrings.append("href=\"https://drommgirls.com/content")
        ident.endStrings.append(".jpeg")
        ident.filetypeString = ".jpg"
        ident.removeCharactersFromStart = 6
        ident.addCharactersAtEnd = 5
        item.websideParseInformation.append(ident)
        websites.append(item)
        
        item = WebsiteRepositoryItem()
        item.websiteIdentification = "http://www.babehub.com"
        ident = WebsiteParseInformation()
        ident.startStrings.append("href=\"http://cdn1.babehub.com/content")
        ident.endStrings.append(".jpg")
        ident.filetypeString = ".jpg"
        ident.removeCharactersFromStart = 6
        ident.addCharactersAtEnd = 4
        item.websideParseInformation.append(ident)
        websites.append(item)
        
        item = WebsiteRepositoryItem()
        item.websiteIdentification = "http://pmatehunter.com";
        ident = WebsiteParseInformation()
        ident.startStrings.append("href=\"http://cdn1.pmatehunter.com/content")
        ident.endStrings.append(".jpg")
        ident.filetypeString = ".jpg"
        ident.removeCharactersFromStart = 6
        ident.addCharactersAtEnd = 4
        item.websideParseInformation.append(ident)
        websites.append(item)
        
        item = WebsiteRepositoryItem()
        item.websiteIdentification = "www.hqsluts.com";
        ident = WebsiteParseInformation()
        ident.startStrings.append("href=\"http://cdn.hqsluts.com/")
        ident.endStrings.append(".jpg")
        ident.filetypeString = ".jpg"
        ident.removeCharactersFromStart = 6
        ident.addCharactersAtEnd = 4
        item.websideParseInformation.append(ident)
        websites.append(item)
        
        item = WebsiteRepositoryItem()
        item.websiteIdentification = "hentai-cosplays.com";
        ident = WebsiteParseInformation()
        ident.startStrings.append("<div class=\"icon-overlay\">")
        ident.startStrings.append("<img src=")
        ident.endStrings.append(".jpg")
        ident.filetypeString = ".jpg";
        ident.removeCharactersFromStart = 10;
        ident.addCharactersAtEnd = 4;
        ident.followupPageIdentifier = "\">next&gt;</a>"
        ident.followUpClosure =
            { (text:String) -> String in
                var substring = ""
                
                // Bis zum Ende abschneiden
                if let range:Range<String.Index> = text.range(of: "\">next&gt;</a>")
                {
                    substring = String(text[..<range.lowerBound])
                    
                    // Vom gesuchten Punkt bis zum Ende abschneiden
                    if let range = substring.range(of: "<a href=\"", options: NSString.CompareOptions.backwards)
                    {
                        let stringRange = substring.range(of: substring)!
                        substring = String(substring[range.upperBound..<stringRange.upperBound])
                        substring = "https://hentai-cosplays.com" + substring
                    }
                }
                return substring
            }
        item.websideParseInformation.append(ident)
        websites.append(item)
    }
    
    // Diese Methode prüft, ob im HTML source der geladenen Seite
    // die identification eines der WebsiteRepositoryItem gefunden werden kann.
    func identifyMatchingRepositoryItem(htmlSource:String) -> WebsiteRepositoryItem?
    {
        for  item in self.websites
        {
            print("Checking WebsiteRepositoryItem: \(item.websiteIdentification)")
            if htmlSource.caseInsensitiveContains(searchString:  item.websiteIdentification)
            {
                print("Match WebsiteRepositoryItem: \(item.websiteIdentification)")
                return item;
            }
        }
        return nil
    }
    
    // Find the correct WebsiteParseInformation for this HTML and WebsiteRepositoryItem
    func identifyMatchingParseInformation(htmlSource:String, item : WebsiteRepositoryItem) -> WebsiteParseInformation?
    {
        // If the Item has only one set of ParseInformation we have to use it
        if item.websideParseInformation.count == 1 {
            return item.websideParseInformation.first
        }
        
        for  info in item.websideParseInformation
        {
            print("Checking WebsiteParseInformation: \(info.parseIdentification)")
            
            if htmlSource.caseInsensitiveContains(searchString: info.parseIdentification)
            {
                print("Match WebsiteParseInformation: \(info.parseIdentification)")
                return info;
            }
        }
        return nil
    }
}
