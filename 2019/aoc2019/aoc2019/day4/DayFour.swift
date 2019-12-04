//
//  DayFour.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/4/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DayFour: AdventDay {
    var dayNumber: Int = 4

    let passwordRange = 171309...643603

    // override since we have no input for this day
    var defaultInput: String? { "" }

    func partOne(input: String?) -> Any {
        let validPasswords = passwordRange.filter { $0.validPassword }
        return validPasswords.count
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}

extension Int {
    var validPassword: Bool {
        let digits = String(self).compactMap { Int(String($0)) }

        // must be 6 digits long
        guard digits.count == 6 else { return false }

        // are digits in ascending order?
        let sortedDigits = digits.sorted()
        guard sortedDigits == digits else { return false }

        // contains at least two sequential digits that are the same
        let pairs = digits.strideByPairs()
        guard pairs.first(where: { $0.first == $0.last }) != nil else { return false }

        return true
    }
}

extension Collection {
    func strideByPairs() -> [[Self.Element]] {
        indices.compactMap { idx -> [Self.Element]? in
            let nextIdx = index(idx, offsetBy: 2)
            guard nextIdx <= endIndex else { return nil } // hit the end
            return Array(self[idx..<nextIdx])
        }
    }
}
