//
//  DaySeventeen.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/19/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DaySeventeen: AdventDay {

    struct SpinLock {
        var buffer: [Int] = [0]
        var currentIndex: Int = 0

        mutating func spin(count: Int) {
            printState()
            
            for nextValue in (1..<2018) {
                let nextIndex = ((currentIndex + count) % buffer.count) + 1
                buffer.insert(nextValue, at: nextIndex)
                currentIndex = nextIndex

                printState()
            }
        }

        func printState() {
            let output = buffer.enumerated().map { (idx, value) -> String in
                return idx == currentIndex ? "(\(value))" : "\(value)"
            }.joined(separator: " ")
            print(output)
        }
    }

    // MARK: -

    func defaultInput() -> String? {
        return "344"
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 17: 💥 NO INPUT")
            exit(10)
        }

        guard let spinCount = Int(runInput) else {
            print("Day 17: Bad input... \(runInput)")
            exit(11)
        }

        let thing = partOne(input: spinCount)
        guard let answer = thing else {
            print("Day 17: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 17: (Part 1) Answer ", answer)

        // ...
    }

    // MARK: -

    func partOne(input: Int) -> Int? {
        return nil
    }

    func partTwo(input: Int) -> Int? {
        return nil
    }
}

