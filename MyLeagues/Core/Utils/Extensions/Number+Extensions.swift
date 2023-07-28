//
//  Number+Extensions.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

extension Array where Element == Int {
    var average: Int {
        return self.reduce(0, +) / self.count
    }
}

extension Array where Element == Double {
    var average: Double {
        return self.reduce(0.0, +) / Double(self.count)
    }
    
    var sum: Double {
        return self.reduce(0.0, +)
    }
}
