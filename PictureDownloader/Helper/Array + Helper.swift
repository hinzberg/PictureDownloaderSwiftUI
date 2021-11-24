//
//  Array + Helper.swift
//  Picture Downloader
//
//  Created by Holger Hinzberg on 23.11.21.
//

import Foundation

extension Array where Element: Equatable {
    func all(where predicate: (Element) -> Bool) -> [Element]  {
        return self.compactMap { predicate($0) ? $0 : nil }
    }
}
