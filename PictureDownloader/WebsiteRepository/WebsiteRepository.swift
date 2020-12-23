//
//  WebsiteRepository.swift
//  PictureDownloaderSwift
//
//  Created by Holger Hinzberg on 14.06.14.
//  Copyright (c) 2014 Holger Hinzberg. All rights reserved.
//

import Foundation

class WebsiteRepository
{
    var websites = [WebsiteRepositoryItem]()
    
    init()
    {
        var item = WebsiteRepositoryItem()
        item.identification = "http://www.playboyblog.com/wp-content";
        item.startStrings.append("href=\'http://www.playboyblog.com/wp-content/uploads")
        item.endStrings.append(".jpg");
        item.filetypeString = ".jpg";
        item.removeCharactersFromStart = 6;
        item.addCharactersAtEnd = 4
        websites.append(item)

        item = WebsiteRepositoryItem()
        item.identification = "https://octokuro.com/gallery/";
        item.startStrings.append("href=\"/images/previews/")
        item.endStrings.append(".jpg")
        item.filetypeString = ".jpg"
        item.removeCharactersFromStart = 6
        item.addCharactersAtEnd = 4
        item.imageUrlAdditionalPrefix = "https://octokuro.com"
        websites.append(item)
        
        /*
        <div href="/images/previews/Blueberry_Haze/full_blueberryhaze_00_CFB2EFDB32.jpg" itemprop="contentUrl" data-size="1333x2000"><img src="/images/previews/Blueberry_Haze/thumb_blueberryhaze_00_CFB2EFDB32.jpg" itemprop="thumbnailUrl"></div>
 */
 
 
        item = WebsiteRepositoryItem()
        item.identification = "http://www.centerfoldlist.com/feed/";
        item.startStrings.append("href=\'http://www.centerfoldlist.com/galleries")
        item.endStrings.append(".jpg")
        item.filetypeString = ".jpg"
        item.removeCharactersFromStart = 6
        item.addCharactersAtEnd = 4
        websites.append(item)
        
        item = WebsiteRepositoryItem()
        item.identification = "http://www.babehub.com"
        item.startStrings.append("href=\"http://cdn1.babehub.com/content")
        item.endStrings.append(".jpg")
        item.filetypeString = ".jpg"
        item.removeCharactersFromStart = 6
        item.addCharactersAtEnd = 4
        websites.append(item)
        
        item = WebsiteRepositoryItem()
        item.identification = "http://pmatehunter.com";
        item.startStrings.append("href=\"http://cdn1.pmatehunter.com/content")
        item.endStrings.append(".jpg")
        item.filetypeString = ".jpg"
        item.removeCharactersFromStart = 6
        item.addCharactersAtEnd = 4
        websites.append(item)

        item = WebsiteRepositoryItem()
        item.identification = "www.hqbabes.com";
        item.startStrings.append("href=\"//c.xme.net/")
        item.endStrings.append(".jpg")
        item.filetypeString = ".jpg"
        item.removeCharactersFromStart = 6
        item.addCharactersAtEnd = 4
        item.imageUrlAdditionalPrefix = "https:"
        websites.append(item)
        
        item = WebsiteRepositoryItem()
        item.identification = "www.hqsluts.com";
        item.startStrings.append("href=\"http://cdn.hqsluts.com/")
        item.endStrings.append(".jpg")
        item.filetypeString = ".jpg"
        item.removeCharactersFromStart = 6
        item.addCharactersAtEnd = 4
        websites.append(item)
        
        item = WebsiteRepositoryItem()
        item.identification = "hentai-cosplays.com";
        item.startStrings.append("<div class=\"icon-overlay\">")
        item.startStrings.append("<img src=")
        item.endStrings.append(".jpg")
        item.filetypeString = ".jpg";
        item.removeCharactersFromStart = 10;
        item.addCharactersAtEnd = 4;
        
       item.followupPageIdentifier = "\">next&gt;</a>"
        item.followUpClosure =
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
       
        websites.append(item)
    }
    
    // Diese Methode prüft, ob im HTML source der geladenen Seite
    // die identification eines der WebsiteRepositoryItem gefunden werden kann.
    func getItemForIdentification(ident:String) -> [WebsiteRepositoryItem]
    {
        var items = [WebsiteRepositoryItem]()
        
        for  item in self.websites
        {
            // print("Checking: \(item.identification)")
            
            if ident.caseInsensitiveContains(substring: item.identification)
            {
                items.append(item)
                // print("Match found: \(item.identification)")
            }
        }
        return items;
    }
}
