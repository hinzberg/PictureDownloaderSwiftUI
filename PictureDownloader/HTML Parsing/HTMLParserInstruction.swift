//
//  HTMLParserInstruction.swift
//  Picture Downloader
//
//  Created by Holger Hinzberg on 31.07.22.
//

import Foundation

public typealias HTMLTitleParserInstruction = (String) -> String
public typealias HTMLLinksParserInstruction = (String) -> [String]

public class HTMLParserInstruction
{
    var titleParseInstrution : HTMLTitleParserInstruction? = nil
    var linksParseInstruction :HTMLLinksParserInstruction? = nil
}
