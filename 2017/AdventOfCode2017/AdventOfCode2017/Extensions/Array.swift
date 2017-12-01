//
//  Array.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/1/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension Array where Element == Int {
    /// Create pairs out of an array of Ints. Loops at the end to include last and first elements.
    func pairs() -> [(Int, Int)]? {
        return enumerated().map { offset, element -> (Int, Int) in
            guard offset + 1 < self.count else {
                // loop back to beginning
                return (element, self[0])
            }

            return (element, self[offset+1])
        }
    }
}
