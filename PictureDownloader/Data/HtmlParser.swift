//  HtmlParser.swift
//  PictureDownloaderSwift
//  Created by Holger Hinzberg on 27.10.14.
//  Copyright (c) 2014 Holger Hinzberg. All rights reserved.

import Cocoa

public class HtmlParser: NSObject
{
    private let parseInfo:WebsiteParseInformation
    
    init(parseInformation:WebsiteParseInformation)
    {
        parseInfo = parseInformation
    }
    
    public func getImageArray(sourceParam:String) -> ([String])
    {
        var source = sourceParam
        
        var imageArray = [String]()
        var imageLink = self.getNextImageLink(sourceParam: source)
        
        while imageLink != nil
        {
            // do not add duplicate links
            if imageArray.contains(imageLink!) == false {
                imageArray.append(imageLink!)
            }
            
            // den Bekannten ImageLink aus dem Code entfernen
            source = self.getSourceAfterImageLink(sourceParam: source, imageLink: imageLink!)
            imageLink = self.getNextImageLink(sourceParam: source)
        }
      
        // An die Bilder URLs zusätzlich einen Prefix
        // anhängen, wenn nötig
        if  parseInfo.imageUrlAdditionalPrefix != ""
        {
            var modifiedImageArray = [String]()
            for image in imageArray
            {
                modifiedImageArray.append(parseInfo.imageUrlAdditionalPrefix + image)
            }
            imageArray = modifiedImageArray
        }
        
        return imageArray
    }
    
    private func getSourceAfterImageLink(sourceParam:String, imageLink:String) -> (String)
    {
        var source = sourceParam
        // den Bekannten ImageLink aus dem Code entfernen
        if imageLink != ""
        {
            source = source.substringRightOf(searchString: imageLink)
        }
        return source
    }
    
    private func getNextImageLink(sourceParam:String) -> (String?)
    {
        var source = sourceParam
        
        // Anfang abschneiden
        for text in parseInfo.startStrings
        {
            let theRange = source.range(of: text, options: NSString.CompareOptions.caseInsensitive)
            if theRange != nil
            {
                //source = source.substring(from: theRange!.lowerBound)
                source = String(source[theRange!.lowerBound...])
            }
            else
            {
                return nil;
            }
        }
        
        
        // Ende abschneiden
        for text in parseInfo.endStrings
        {
            let theRange = source.range(of:text, options: NSString.CompareOptions.caseInsensitive)
            if theRange != nil
            {
                // source = source.substring(to: theRange!.lowerBound)
                source  = String(source[..<theRange!.upperBound])
            }
            else
            {
                return nil;
            }
        }
        
        // Beliebige Anzahl von zeichem vom Start abscheiden
        // Eigene Methode aus HHSStringHelper
        source = source.substringRightFrom(characterCount: parseInfo.removeCharactersFromStart)
        return source
    }
    
    public func getHtmlTitle(htmlSource:String) -> String
    {
        var title = cutStringBetween(sourceParam: htmlSource, startString: "<title", endString: "</title>")
        title = title.substringRightOf(searchString: ">")
        title = title.fixEncoding()
        title = title.removeInvalidFilenameCharacters()
        return title
    }
    
    public func cutStringBetween(sourceParam:String, startString:String, endString:String) -> (String)
    {
        var source = sourceParam
        
        let startRange = source.range(of: startString, options: NSString.CompareOptions.caseInsensitive)
        if startRange != nil
        {
            //source = source.substring(from: startRange!.upperBound)
            source = String(source[startRange!.upperBound...])
            let endRange = source.range(of: endString, options: NSString.CompareOptions.caseInsensitive)
            if endRange != nil
            {
                //source = source.substring(to: endRange!.lowerBound)
                source  = String(source[..<endRange!.lowerBound])
                return source
            }
        }
        return ""
    }
    
    func getLinkToFollowupPage(sourceParam:String) -> (String)
    {
        var followUpLink = ""
        if sourceParam.contains(parseInfo.followupPageIdentifier)
        {
            if let closure = parseInfo.followUpClosure
            {
                    followUpLink = closure(sourceParam)
            }
        }
        return followUpLink
    }
}
