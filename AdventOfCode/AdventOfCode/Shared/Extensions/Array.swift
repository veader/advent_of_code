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
        // Why not just use Set here?...
    }

    /// Return the middle index of the given array based on length.
    ///
    /// - note: Array with even number of elements might be considered "off"
    var middleIndex: Int {
        return count / 2
    }

    /// Is the given array the same as this array, except for one element?
    func offByOne(from other: Array) -> Bool {
        guard count == other.count else { return false } // must be the same size
        guard self != other else { return false } // must not be equal (completely)
        
        var foundOne = false
        for x in self.indices {
            if self[x] != other[x] {
                if !foundOne {
                    foundOne = true // found first different element
                } else {
                    return false // found second different element
                }
            }
        }
        
        return true
    }

    /// Return (unique) combination pairs for the items in the array
    func pairCombinations() -> [[Element]] {
        guard count > 1 else { return [] } // no combinations

        var combinations: [[Element]] = []
        enumerated().forEach { (index, element) in
            var idx = index + 1
            while idx < count {
                combinations.append([element, self[idx]])
                idx+=1
            }
        }
        return combinations
    }
}

extension Array where Element == Int {
    /// Does this array only contain zeros?
    var allZeros: Bool {
        let set = Set(self)
        return set.count == 1 && set.contains(0)
    }
}
