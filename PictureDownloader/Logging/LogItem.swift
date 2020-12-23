//  LogItem.swift
//  Picture Downloader
//  Created by Holger Hinzberg on 08.12.20.

import Foundation   

public enum LogItemPriority {
    case Information
    case Exclamation
}

public class LogItem : Identifiable {
    
    public var id = UUID()
    public var message : String = ""
    public var date = Date()
    public var priority = LogItemPriority.Information
        
    init(message : String) {
        self.message = message
    }
    
    init(message : String, priority : LogItemPriority ) {
        self.message = message
        self.priority = priority
    }
}
