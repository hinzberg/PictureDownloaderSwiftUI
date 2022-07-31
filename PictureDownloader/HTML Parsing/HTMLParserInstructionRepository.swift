//
//  HTMLParserInstructionRepository.swift
//  Picture Downloader
//
//  Created by Holger Hinzberg on 31.07.22.
//

import Foundation

public class HTMLParserInstructionRepository
{
    public static func babesourceParserInstruction() -> HTMLParserInstruction {
        
        let instructions = HTMLParserInstruction()
        instructions.titleParseInstrution = genericTitleParser
        instructions.linksParseInstruction = babesourceLinksParser
        return instructions
    }
    
    private static func genericTitleParser(htmlSource : String) -> String
    {
        var title = htmlSource.substringBetween(startString: "<title", endString: "</title>")
        title = title.substringAfter(searchString: ">")
        title = title.fixEncoding()
        title = title.removeInvalidFilenameCharacters()
        return title
    }
    
    private static func babesourceLinksParser (htmlSource : String) -> [String]
    {
        let startString = "href=\"https://media.babesource.com/galleries/"
        let endString  = ".jpg"
        let removeCharactersFromStart = 6
        var source = htmlSource
        var linksArray = [String]()
        var singleLink : String = ""
        
        while source.caseInsensitiveContains(searchString: startString)  {
            
            singleLink = source.substringAfterIncluding(searchString: startString, options: NSString.CompareOptions.caseInsensitive)
            singleLink = singleLink.substringBeforeIncluding(searchString: endString, options: NSString.CompareOptions.caseInsensitive)
            
            // Remove a given number of characters from the start
            // This can be neccessary if there is no other way to identify an URL
            if removeCharactersFromStart > 0 {
                singleLink = singleLink.substringRightAfter(characterCount: removeCharactersFromStart)
            }
            
            while singleLink != "" {
                // No duplicates
                if linksArray.contains(singleLink) == false {
                    linksArray.append(singleLink)
                }
                // remove found ImageLink from HTML source code
                source = source.substringAfter(searchString: singleLink)
                linksArray.append(singleLink)
                singleLink = ""
            }
        }
        
        return linksArray
    }
}
