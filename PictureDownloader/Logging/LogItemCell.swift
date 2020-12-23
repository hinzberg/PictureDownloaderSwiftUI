//  LogItemCell.swift
//  Picture Downloader
//  Created by Holger Hinzberg on 08.12.20.

import SwiftUI

struct LogItemCell: View {
    
    var logItem : LogItem
    
    static let timeFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var body: some View {
        HStack {
            self.priorityView()
            Text( "\(logItem.date, formatter: Self.timeFormat)").font(.title2)
            Text(logItem.message).font(.title2)
            Spacer()
        }.padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 0))
    }
    
    private func priorityView() -> AnyView {
        switch logItem.priority {
        case .Information: return AnyView( Image(systemName: "info.circle").font(.title2) .foregroundColor(.green) )
        case .Exclamation: return AnyView( Image(systemName: "exclamationmark.triangle").font(.title2) .foregroundColor(.red))
        }
    }
    
    
    
}





struct LogItemCell_Previews: PreviewProvider {
    
    static var previews: some View {
        LogItemCell(logItem: LogItem(message: "Hello World")  )
    }
}
