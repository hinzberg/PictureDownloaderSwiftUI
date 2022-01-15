//  IRepositoryProtocol.swift
//  Picture Downloader
//  Created by Holger Hinzberg on 30.11.21.

import Foundation

protocol IRepositoryProtocol {
    associatedtype T
    //associatedtype U
    
    func addItems(itemsArray: [T])
    func addItem(item: T)
    func removeItem(item: T)
    func removeAllItems()
    func getItemCount() -> Int
}
