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

        init(_ str: String) {
            value = str
        }

        func isValid() -> Bool {
            let words = value.split(separator: " ").map(String.init)
            return Set(words).count == words.count
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

        // ...
    }

    // MARK: -

    func partOne(input: [String]) -> Int? {
        let passphrases = input.map(Passphrase.init)
        let validPhrases = passphrases.filter { $0.isValid() }
        return validPhrases.count
    }

    func partTwo(input: [String]) -> Int? {
        return nil
    }
}
