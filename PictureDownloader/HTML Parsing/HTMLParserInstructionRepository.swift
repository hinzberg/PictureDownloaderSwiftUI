//
//  HTMLParserInstructionRepository.swift
//  Picture Downloader
//
//  Created by Holger Hinzberg on 31.07.22.
//

import Foundation

public class HTMLParserInstructionRepository
{
    private var htmlParserInstructions = [HTMLParserInstruction]()
    
    init  () {
        htmlParserInstructions.append( self.babesourceParserInstruction())
        htmlParserInstructions.append( self.cosplayThotsParserInstruction())
        htmlParserInstructions.append( self.hqBabesParserInstruction())
    }
    
    public func getMatchingParseInstruction(htmlSource:  String) -> HTMLParserInstruction? {
        
        for instruction in self.htmlParserInstructions {
            if let identifier = instruction.identifierInstruction {
                if identifier(htmlSource) == true {
                    return instruction
                }
            }
        }
        return nil
    }
    
    private func babesourceParserInstruction() -> HTMLParserInstruction {
        let instructions = HTMLParserInstruction()
        instructions.name = "Babesource"
        instructions.identifierInstruction = babesourceIdentifierInstruction
        instructions.titleParseInstruction = genericTitleParser
        instructions.linksParseInstruction = babesourceLinksParser
        return instructions
    }
    
    private func cosplayThotsParserInstruction() -> HTMLParserInstruction {
        let instructions = HTMLParserInstruction()
        instructions.name = "CosplayThots"
        instructions.identifierInstruction  = cosplayThotsIdentifierInstruction
        instructions.titleParseInstruction = cosplayThotsTitleParser
        instructions.linksParseInstruction = cosplayThotsLinksParser
        return instructions
    }
    
    private func hqBabesParserInstruction() -> HTMLParserInstruction {
        let instructions = HTMLParserInstruction()
        instructions.name = "HQBabes"
        instructions.identifierInstruction = hqBabesIdentifierInstruction
        instructions.titleParseInstruction = genericTitleParser
        instructions.linksParseInstruction = hqBabesLinksParser
        return instructions
    }
    
    // MARK: Identifier
    
    private func hqBabesIdentifierInstruction(htmlSource : String) -> Bool {
        if htmlSource.caseInsensitiveContains(searchString: "www.hqbabes.com") {
            return true
        }
        return false
    }
    
    private func cosplayThotsIdentifierInstruction(htmlSource : String) -> Bool {
        if htmlSource.caseInsensitiveContains(searchString: "cosplaythots.com") {
            return true
        }
        return false
    }
    
    private func babesourceIdentifierInstruction(htmlSource : String) -> Bool {
        if htmlSource.caseInsensitiveContains(searchString: "https://babesource.com/galleries/") {
            return true
        }
        return false
    }
    
    // MARK: Title Parser
    
    private func genericTitleParser(htmlSource : String) -> String
    {
        var title = htmlSource.substringBetween(startString: "<title", endString: "</title>")
        title = title.substringAfter(searchString: ">")
        title = title.fixEncoding()
        title = title.removeInvalidFilenameCharacters()
        return title
    }
    
    private func cosplayThotsTitleParser(htmlSource : String) -> String
    {
        var title = htmlSource.substringBetween(startString: "<title", endString: "</title>")
        title = title.substringAfter(searchString: ">")
        title = title.fixEncoding()
        title = title.removeInvalidFilenameCharacters()
        title = title.replacingOccurrences(of: "Onlyfans, Patreon, Fansly cosplay leaked images and videos", with: "")
        if title.caseInsensitiveContains(searchString: "  - ") {
            title = title.substringBefore(searchString: "  - ")
        }
        title = title.trim()
        return title
    }
    
    // MARK: Links Parser
    
    private func babesourceLinksParser (htmlSource : String) -> [String]
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
            
            if singleLink != "" {
                // No duplicates
                if linksArray.contains(singleLink) == false {
                    linksArray.append(singleLink)
                }
                // remove found ImageLink from HTML source code
                source = source.substringAfter(searchString: singleLink)
                singleLink = ""
            }
        }
        return linksArray
    }
    
    private func cosplayThotsLinksParser (htmlSource : String) -> [String]
    {
        let startString = "href=\"https://cosplaythots.com/images/"
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
            
            if singleLink != "" {
                // No duplicates
                if linksArray.contains(singleLink) == false {
                    linksArray.append(singleLink)
                }
                // remove found ImageLink from HTML source code
                source = source.substringAfter(searchString: singleLink)
                singleLink = ""
            }
        }
        return linksArray
    }
    
    private func hqBabesLinksParser (htmlSource : String) -> [String]
    {
        let startString = "href=\"//c.xme.net/"
        let endString  = ".jpg"
        let removeCharactersFromStart = 6
        var source = htmlSource
        var linksArray = [String]()
        var singleLink : String = ""
        let imageUrlAdditionalPrefix = "https:"
        
        while source.caseInsensitiveContains(searchString: startString)  {
            
            singleLink = source.substringAfterIncluding(searchString: startString, options: NSString.CompareOptions.caseInsensitive)
            singleLink = singleLink.substringBeforeIncluding(searchString: endString, options: NSString.CompareOptions.caseInsensitive)
            
            // Remove a given number of characters from the start
            // This can be neccessary if there is no other way to identify an URL
            if removeCharactersFromStart > 0 {
                singleLink = singleLink.substringRightAfter(characterCount: removeCharactersFromStart)
            }
            
            if singleLink != "" {
                let  modifiedLink = "\(imageUrlAdditionalPrefix)\(singleLink)"
                // No duplicates
                if linksArray.contains(modifiedLink) == false {
                    linksArray.append(modifiedLink)
                }
                // remove found ImageLink from HTML source code
                source = source.substringAfter(searchString: singleLink)
                singleLink = ""
            }
        }
        return linksArray
    }
}
