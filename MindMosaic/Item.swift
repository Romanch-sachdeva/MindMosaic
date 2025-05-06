//
//  Item.swift
//  MindMosaic
//
//  Created by Romanch Sachdeva on 1/5/2025.
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
