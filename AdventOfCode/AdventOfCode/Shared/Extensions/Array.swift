//
//  Array.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/7/20.
//

import Foundation

extension Array where Element: Equatable {
    /// Returns a new version of this array removing duplicate entries
    func unique() -> [Element] {
        reduce([]) { result, element -> [Element] in
            result.contains(element) ? result : result + [element]
        }
    }
}
