//
//  Item.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
