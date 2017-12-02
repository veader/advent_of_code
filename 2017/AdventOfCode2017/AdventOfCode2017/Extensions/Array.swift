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

    /// Create pairs of elements with distance to second element being index/2.
    func halfDistancePairs() -> [(Int, Int)]? {
        // array *must* have even number of elements
        guard self.count % 2 == 0 else { return nil }

        return enumerated().map { offset, element -> (Int, Int) in
            let halfOffset = (offset + (self.count / 2)) % self.count
            return (element, self[halfOffset])
        }
    }

    func dividablePair() -> (Int, Int)? {
        for (idx, x) in enumerated() {
            let cdr = suffix(from: idx + 1)
            guard let evenlyDiv = cdr.first(where: { Swift.max(x, $0) % Swift.min(x, $0) == 0})
                  else { continue }

            return (Swift.max(x, evenlyDiv), Swift.min(x, evenlyDiv))
        }

        return nil
    }
}
