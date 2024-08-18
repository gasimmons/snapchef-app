//
//  Item.swift
//  SnapChef
//
//  Created by Gavin Simmons on 8/17/24.
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
