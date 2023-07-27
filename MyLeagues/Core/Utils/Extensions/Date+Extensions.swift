//
//  Date+Extensions.swift
//  Engine
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

extension Date {
    var isToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }
}
