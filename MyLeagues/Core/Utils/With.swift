//
//  With.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

public func with<T>(_ object: T, configure: (inout T) -> Void) -> T {
    var object = object
    configure(&object)
    return object
}
