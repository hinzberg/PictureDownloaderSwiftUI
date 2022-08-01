//  HTMLParserInstruction.swift
//  Picture Downloader
//  Created by Holger Hinzberg on 31.07.22.

import Foundation

public typealias HTMLTitleParserInstruction = (String) -> String
public typealias HTMLLinksParserInstruction = (String) -> [String]
public typealias HTMLIdentifierInstruction = (String) -> Bool

public class HTMLParserInstruction
{
    var name : String = ""
    var identifierInstruction : HTMLIdentifierInstruction? = nil
    var titleParseInstruction : HTMLTitleParserInstruction? = nil
    var linksParseInstruction :HTMLLinksParserInstruction? = nil
}
