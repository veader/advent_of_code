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
        let spinSize: Int

        init(size: Int) {
            spinSize = size
        }

        var printableState: String {
            return buffer.enumerated().map { (idx, value) -> String in
                return idx == currentIndex ? "(\(value))" : "\(value)"
            }.joined(separator: " ")
        }

        mutating func spin(count: Int, printing: Bool = false) {
            if printing { printState() }
            
            for nextValue in (1...count) {
                let nextIndex = ((currentIndex + spinSize) % buffer.count) + 1
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

        let thing2 = partTwo(input: spinCount)
        guard let answer2 = thing2 else {
            print("Day 17: (Part 2) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 17: (Part 2) Answer ", answer2)
    }

    // MARK: -

    func partOne(input: Int) -> Int? {
        var spinlock = SpinLock(size: input)
        spinlock.spin(count: 2017)
        guard let thisIndex = spinlock.buffer.index(of: 2017) else { return nil }
        return spinlock.buffer[thisIndex.advanced(by: 1)]
    }

    func partTwo(input: Int) -> Int? {
        print(Date())
        var spinlock = SpinLock(size: input)
        spinlock.spin(count: 50_000_000)
        guard let thisIndex = spinlock.buffer.index(of: 0) else { return nil }
        print(Date())
        return spinlock.buffer[thisIndex.advanced(by: 1)]
    }
}

