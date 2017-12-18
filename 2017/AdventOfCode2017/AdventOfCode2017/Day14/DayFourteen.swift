//
//  DayFourteen.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/15/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DayFourteen: AdventDay {

    struct Disk {
        //
    }

    // MARK: -

    func defaultInput() -> String? {
        return ""
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 14: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 14: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 14: (Part 1) Answer ", answer)

        // ...
    }

    // MARK: -

    func partOne(input: String) -> Int? {
        return nil
    }

    func partTwo(input: String) -> Int? {
        return nil
    }
}

extension DayFourteen: Testable {
    func runTests() {
    }
}


