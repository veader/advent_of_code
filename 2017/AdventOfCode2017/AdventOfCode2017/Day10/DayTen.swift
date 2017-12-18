//
//  Day10.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/10/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DayTen: AdventDay {

    // MARK: -

    func defaultInput() -> String? {
        return "120,93,0,90,5,80,129,74,1,165,204,255,254,2,50,113"
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 10: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 10: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 10: (Part 1) Answer ", answer)

        let thing2 = partTwo(input: runInput)
        guard let answer2 = thing2 else {
            print("Day 10: (Part 2) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 10: (Part 2) Answer ", answer2)
    }

    // MARK: -

    func partOne(input: String, count: Int = 256) -> Int? {
        guard var hash = KnotHash(input, length: count) else { return nil }
        hash.hash()

        return (hash.string[0]) * (hash.string[1])
    }

    func partTwo(input: String, count: Int = 256) -> String? {
        guard var hash = KnotHash(input, length: count, useASCII: true) else { return nil }
        return hash.run(rounds: 64)
    }
}
