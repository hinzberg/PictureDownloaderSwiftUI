//  HtmlParser.swift
//  PictureDownloaderSwift
//  Created by Holger Hinzberg on 27.10.14.
//  Copyright (c) 2014 Holger Hinzberg. All rights reserved.

import Cocoa
import Hinzberg_Foundation

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
            
            // remove found ImageLink from HTML source code
            source = source.substringAfter(searchString: imageLink!)
            imageLink = self.getNextImageLink(sourceParam: source)
        }
      
        // Add a prefix to the image URLs if neccessary
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
        
    private func getNextImageLink(sourceParam:String) -> (String?)
    {
        var source = sourceParam
        
        // Cut at start
        for text in parseInfo.startStrings
        {
            if  source.caseInsensitiveContains(searchString: text)
            {
                source = source.substringAfterIncluding(searchString: text, options: NSString.CompareOptions.caseInsensitive)
            }
            else
            {
                return nil;
            }
        }
        
        // Cut at end
        for text in parseInfo.endStrings
        {
            if  source.caseInsensitiveContains(searchString: text)
            {
                source = source.substringBeforeIncluding(searchString: text, options: NSString.CompareOptions.caseInsensitive)
            }
            else
            {
                return nil;
            }
        }

        // Remove a given number of characters from the start
        // This can be neccessary if there is no other way to identify an URL
        source = source.substringRightAfter(characterCount: parseInfo.removeCharactersFromStart)
        return source
    }
    
    public func getHtmlTitle(htmlSource:String) -> String
    {
        var title = getSubstringBetween(sourceParam: htmlSource, startString: "<title", endString: "</title>")
        title = title.substringAfter(searchString: ">")
        title = title.fixEncoding()
        title = title.removeInvalidFilenameCharacters()
        return title
    }
    
    private func getSubstringBetween(sourceParam:String, startString:String, endString:String) -> (String)
    {
        var source = sourceParam
        
        if source.caseInsensitiveContains(searchString: startString)
        {
            source = source.substringAfter(searchString: startString)
            if source.caseInsensitiveContains(searchString: endString)
            {
                source = source.substringBefore(searchString: endString)
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
