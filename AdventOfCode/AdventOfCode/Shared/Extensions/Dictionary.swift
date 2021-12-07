//
//  Dictionary.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/7/21.
//

import Foundation

extension Dictionary where Value == Int {
    mutating func incrementing(_ key: Key, by update: Int) {
        self[key] = (self[key] ?? 0) + update
    }
}
