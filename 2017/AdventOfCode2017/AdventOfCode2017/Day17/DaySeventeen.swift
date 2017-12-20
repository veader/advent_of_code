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

        var printableState: String {
            return buffer.enumerated().map { (idx, value) -> String in
                return idx == currentIndex ? "(\(value))" : "\(value)"
            }.joined(separator: " ")
        }

        mutating func spin(count: Int, printing: Bool = false) {
            if printing { printState() }
            
            for nextValue in (1..<2018) {
                let nextIndex = ((currentIndex + count) % buffer.count) + 1
                buffer.insert(nextValue, at: nextIndex)
                currentIndex = nextIndex

                if printing { printState() }
            }
        }

        func printState() {
            print(printableState)
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
        var spinlock = SpinLock()
        spinlock.spin(count: input)
        guard let thisIndex = spinlock.buffer.index(of: 2017) else { return nil }
        return spinlock.buffer[thisIndex.advanced(by: 1)]
    }

    func partTwo(input: Int) -> Int? {
        return nil
    }
}

