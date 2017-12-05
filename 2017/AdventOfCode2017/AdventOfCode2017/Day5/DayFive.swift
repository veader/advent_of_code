//
//  DayFive.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/5/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DayFive: AdventDay {

    struct JumpInstructions: CustomDebugStringConvertible {
        /// Jump instructions to execute
        var instructions = [Int]()

        /// Current index within the instructions
        var currentIndex = 0

        /// Number of steps executed during a run
        var steps = 0

        init(_ input: [Int]) {
            instructions = input
        }

        /// Start executing the
        mutating func run() -> Int {
            let instructionRange = 0..<instructions.count
            currentIndex = 0 // make sure to start at the beginning
            steps = 0 // reset step count

            while instructionRange.contains(currentIndex) {
                print(self)
                step()
            }

            return steps
        }

        private mutating func step() {
            let oldIndex = currentIndex

            // move our index by the value of the current instruction
            currentIndex += instructions[currentIndex]

            // increment previous jump instruction
            instructions[oldIndex] += 1

            // count the step
            steps += 1
        }

        var debugDescription: String {
            // show a range of 5 around the current index
            let startIndex = max(0, currentIndex - 5)
            let endIndex = min(instructions.count, currentIndex + 5)

            let instructionsString = (startIndex..<endIndex).map { (idx) -> String in
                let jumpValue = "\(instructions[idx])"
                return idx == currentIndex ? "(\(jumpValue))" : jumpValue
            }.joined(separator: " ")

            return """
                <JumpInstructions:
                    instructions (\(instructions.count)): \(instructionsString)
                    index: \(currentIndex)
                    steps: \(steps)
                >
                """
        }
    }

    // MARK: -

    func defaultInput() -> String? {
        let path = "\(dataPath())/day5input.txt"
        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 5: 💥 NO INPUT")
            exit(10)
        }

        let steps = runInput.split(separator: "\n").flatMap { Int(String($0)) }

        let thing = partOne(input: steps)
        guard let answer = thing else {
            print("Day 5: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 5: (Part 1) Answer ", answer)

        // ...
    }

    // MARK: -

    func partOne(input: [Int]) -> Int? {
        var instructions = JumpInstructions(input)
        let steps = instructions.run()
        return steps
    }

    func partTwo(input: String) -> Int? {
        return nil
    }
}


