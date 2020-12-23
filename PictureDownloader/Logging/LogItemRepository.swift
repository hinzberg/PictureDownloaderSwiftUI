//  LogItemRepository.swift
//  Picture Downloader
//  Created by Holger Hinzberg on 08.12.20.

import Foundation

public class LogItemRepository: ObservableObject {
    
    static let shared = LogItemRepository()
    
    private init() {
    }
    
    @Published var logItems = [LogItem]()
    
    public func addItem(item : LogItem)
    {
        DispatchQueue.main.async {
            self.logItems.insert(item, at: 0)
        }
    }
}
