//
//  BaseRepositoryItem.swift
//  Picture Downloader
//
//  Created by Holger Hinzberg on 03.10.22.
//

import Foundation

public class BaseRepositoryItem : Identifiable, Equatable, ObservableObject {
    
    @Published public var id = UUID()
    @Published var selected : Bool = false
    
    public static func == (lhs: BaseRepositoryItem, rhs: BaseRepositoryItem) -> Bool {
        return lhs.id == rhs.id
    }
}
