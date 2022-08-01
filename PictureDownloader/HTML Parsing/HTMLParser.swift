//  HTMLParser.swift
//  Picture Downloader
//  Created by Holger Hinzberg on 31.07.22.

import Foundation

public class HTMLParser
{
    public func Parse(instruction : HTMLParserInstruction, htmlSource : String) -> HTMLParserResult
    {
        let result = HTMLParserResult()
        
        if let titleParse = instruction.titleParseInstruction {
            result.Title = titleParse(htmlSource)
        }
        
        if let linksParse = instruction.linksParseInstruction {
            result.Links = linksParse(htmlSource)
        }
                
        return result
    }
}
