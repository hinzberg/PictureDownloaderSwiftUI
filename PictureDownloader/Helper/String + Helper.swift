//
//  String + Helper.swift
//  Picture Downloader
//
//  Created by Holger Hinzberg on 31.07.22.
//

import Foundation

extension String
{
    public func substringBetween(startString:String, endString:String) -> (String)
    {
        var source = self
        
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
}


