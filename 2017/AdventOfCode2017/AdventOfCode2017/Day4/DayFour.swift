//
//  DayFour.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/4/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DayFour: AdventDay {
    struct Passphrase {
        let value: String
        let words: [String]

        init(_ str: String) {
            value = str
            words = value.split(separator: " ").map(String.init)
        }

        func isValid(blockAnnagrams: Bool = false) -> Bool {
            return hasNoRepeats() && (!blockAnnagrams || hasNoAnnagrams())
        }

        func hasNoRepeats() -> Bool {
            return Set(words).count == words.count
        }

        func hasNoAnnagrams() -> Bool {
            for word in words {
                // look for words of the same size, sort them all and compare for matches
                let sameLengthWords = words.filter { $0 != word && word.count == $0.count }
                if sameLengthWords.map({ String($0.sorted()) }).contains(String(word.sorted())) {
                    return false
                }
            }

            return true
        }
    }

    // MARK: -

    func defaultInput() -> String? {
        let path = "\(dataPath())/day4input.txt"
        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 4: 💥 NO INPUT")
            exit(10)
        }

        let passphrases = runInput.split(separator: "\n").map(String.init)

        let thing = partOne(input: passphrases)
        guard let answer = thing else {
            print("Day 4: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 4: (Part 1) Answer ", answer)

        let thing2 = partTwo(input: passphrases)
        guard let answer2 = thing2 else {
            print("Day 4: (Part 2) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 4: (Part 2) Answer ", answer2)
    }

    // MARK: -

    func partOne(input: [String]) -> Int? {
        let passphrases = input.map(Passphrase.init)
        let validPhrases = passphrases.filter { $0.isValid() }
        return validPhrases.count
    }

    func partTwo(input: [String]) -> Int? {
        let passphrases = input.map(Passphrase.init)
        let validPhrases = passphrases.filter { $0.isValid(blockAnnagrams: true) }
        return validPhrases.count
    }
}
