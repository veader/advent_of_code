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
        let validPasswords = passwordRange.filter { $0.extraValidPassword }
        return validPasswords.count
    }
}

extension Int {
    var validPassword: Bool { // for part 1
        let digits = String(self).compactMap { Int(String($0)) }

        // must be 6 digits long
        guard digits.count == 6 else { return false }

        // are digits in ascending order?
        let sortedDigits = digits.sorted()
        guard sortedDigits == digits else { return false }

        // contains at least two sequential digits that are the same
        guard digits.duplicateSubSequences().count > 0 else { return false }

        return true
    }

    var extraValidPassword: Bool { // for part 2
        let digits = String(self).compactMap { Int(String($0)) }

        // must be 6 digits long
        guard digits.count == 6 else { return false }

        // are digits in ascending order?
        let sortedDigits = digits.sorted()
        guard sortedDigits == digits else { return false }

        // contains at least two sequential digits that are the same,
        // ... but only if they are not part of a larger sequential run
        let dupes = digits.duplicateSubSequences().filter { $0.count == 2 }
        guard dupes.count > 0 else { return false }

        return true
    }
}

extension Collection where Element : Comparable {
    func duplicateSubSequences() -> [[Self.Element]] {
        var subSequences = [[Self.Element]]()

        var currentElement = self[startIndex]
        var startSeqIdx = startIndex
        var endSeqIdx: Self.Index

        while startSeqIdx < endIndex {
            // move to next item
            endSeqIdx = index(startSeqIdx, offsetBy: 1)
            guard endSeqIdx < endIndex else { break }

            // loop till we aren't matching
            while endSeqIdx < endIndex && self[endSeqIdx] == currentElement {
                endSeqIdx = index(endSeqIdx, offsetBy: 1)
                guard endSeqIdx <= endIndex else { break } // we hit the end
            }

            let sequence = self[startSeqIdx..<endSeqIdx]
            if sequence.count > 1 {
                // save sequences with duplicates
                subSequences.append(Array(sequence))
            }

            guard endSeqIdx < endIndex else { break }

            // move to next sequence
            startSeqIdx = endSeqIdx
            currentElement = self[startSeqIdx]
        }

        return subSequences
    }
}
