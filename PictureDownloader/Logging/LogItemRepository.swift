//  LogItemRepository.swift
//  Picture Downloader
//  Created by Holger Hinzberg on 08.12.20.

import Foundation

public class LogItemRepository: ObservableObject {
    
    @Published var logItems = [LogItem]()
   
    // Make this a singleton
    static let shared = LogItemRepository()
    private init() {}
    
    public func addItem(item : LogItem)
    {
        DispatchQueue.main.async {
            self.logItems.insert(item, at: 0)
        }
    }
}
