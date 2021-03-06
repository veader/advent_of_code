//
//  DayTwo.swift
//  AdventOfCode2018
//
//  Created by Shawn Veader on 12/2/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import Foundation

extension String {

    /// Set of characters contained within this string that are seen a given
    /// number of times. Occurrances of characters are not necessarily consecutive.
    func charactersRepeating(times: Int) -> Set<Character> {
        var set: Set<Character> = Set()

        let sortedString = String(sorted())
        var currentIdx = sortedString.startIndex

        while currentIdx != sortedString.endIndex {
            // look for the distance between this character and the last
            //  occurance of this character
            let c = sortedString[currentIdx]
            if let lastIdx = sortedString.lastIndex(of: c) {
                let theDistance = sortedString.distance(from: currentIdx, to: lastIdx) + 1
                if theDistance >= times {
                    set.insert(c)
                }

                guard lastIdx != sortedString.endIndex else { break }

                // move to the next character after the last one of these
                currentIdx = sortedString.index(after: lastIdx)
            } else {
                // move to the next character
                currentIdx = sortedString.index(after: currentIdx)
            }
        }

        return set
    }

    /// Does the string contain a character that repeats the given number of times?
    func hasCharacterRepeating(times: Int) -> Bool {
        return charactersRepeating(times: times).count > 0
    }

    /// Return the substring occurring after the provided prefix
    func substring(after thePrefix: String, offset additionalOffset: Int = 0) -> String? {
        guard hasPrefix(thePrefix) else { return nil }

        guard let nextIndex = index(startIndex, offsetBy: thePrefix.count + additionalOffset, limitedBy: endIndex) else {
            return nil
        }

        return String(self[nextIndex...])
    }
}

struct DayTwo: AdventDay {

    var dayNumber: Int = 2

    @discardableResult func run(_ input: String? = nil, _ part: Int? = 1) -> Any {
        guard let input = input ?? defaultInput else {
            print("Day \(dayNumber): NO INPUT")
            exit(10)
        }

        if part == 1 {
            let checksum = partOne(input: input)
            print("Day \(dayNumber) Part \(part!): Final Answer \(checksum)")
            return checksum
        } else {
            let matchingChars = partTwo(input: input)
            print("Day \(dayNumber) Part \(part!): Final Answer \(matchingChars)")
            return matchingChars
        }
    }

    func partOne(input: String) -> Int {
        let boxIDs = input.split(separator: "\n").map(String.init)

        var twoCharCount = 0
        var threeCharCount = 0

        for boxID in boxIDs {
            let threeRepeats = boxID.charactersRepeating(times: 3)
            let twoRepeats = boxID.charactersRepeating(times: 2)

            if threeRepeats.count > 0 {
                threeCharCount += 1
            }

            if twoRepeats.subtracting(threeRepeats).count > 0 {
                twoCharCount += 1
            }
        }

        return twoCharCount * threeCharCount // "checksum"
    }

    func partTwo(input: String) -> String {
        let boxIDs = input.split(separator: "\n").map(String.init)

        var closeIDs: Set<String> = Set() // avoid duplicates

        var currentIdx = boxIDs.startIndex
        while currentIdx < boxIDs.endIndex {
            let boxID = boxIDs[currentIdx]

            for otherBoxID in boxIDs[currentIdx...] {
                let prefix = otherBoxID.commonPrefix(with: boxID)

                if  let originalRemainder = boxID.substring(after: prefix, offset: 1),
                    let thisRemainder = otherBoxID.substring(after: prefix, offset: 1) {

                    if originalRemainder == thisRemainder {
                        closeIDs.insert(boxID)
                        closeIDs.insert(otherBoxID)
                    }
                }
            }

            currentIdx = boxIDs.index(after: currentIdx)
        }

        guard closeIDs.count == 2 else { return "" }

        let closeIDsArray = [String](closeIDs) // force into array for easy access
        if let first = closeIDsArray.first, let second = closeIDsArray.last {
            let prefix = second.commonPrefix(with: first)
            let suffix = first.substring(after: prefix, offset: 1) ?? ""

            return "\(prefix)\(suffix)"
        }

        return ""
    }
}
