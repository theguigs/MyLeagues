//
//  Debouncer.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

public class Debouncer {
    private var debounceTimer: Timer?
    
    public init() { }
    
    public func debounce(time: Double = 0.2, completion: @escaping () -> Void) {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: time, repeats: false) { _ in
            completion()
        }
    }
}
