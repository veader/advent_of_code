//
//  DayTwentyFive.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 1/7/18.
//  Copyright © 2018 v8logic. All rights reserved.
//

import Foundation

struct DayTwentyFive: AdventDay {

    struct TuringMachine {
        struct TuringMachineState {
            let name: String
        }

        /// inifinte tape (of 0's to begin with)
        let tape: [Int]

        /// position along the tape
        let cursor: Int = 0

        /// current state
        let state: TuringMachineState

        /// available states
        let states: [TuringMachineState]
    }

    // MARK: -

    func defaultInput() -> String? {
        let path = "\(dataPath())/day25input.txt"
        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 25: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 25: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 25: (Part 1) Answer ", answer)

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
