//
//  DayFifteen.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/18/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DayFifteen: AdventDay {

    struct Generator {
        let factor: Int
        let divisor = 2147483647

        var previous: Int
        let multiple: Int

        mutating func nextValue() -> Int {
            var value: Int
            var tmpPrevious: Int

            tmpPrevious = previous
            repeat {
                value = (tmpPrevious * factor) % divisor
                tmpPrevious = value
            } while (value % multiple) != 0

            previous = value
            return value
        }
    }

    struct Judge {
        var genA: Generator
        var genB: Generator

        init(a: Int, b: Int, useMultiples: Bool = false) {
            if useMultiples {
                genA = Generator(factor: 16807, previous: a, multiple: 4)
                genB = Generator(factor: 48271, previous: b, multiple: 8)
            } else {
                genA = Generator(factor: 16807, previous: a, multiple: 1)
                genB = Generator(factor: 48271, previous: b, multiple: 1)
            }
        }

        mutating func compare(cycles: Int = 10, printing: Bool = false) -> Int {
            var matches = 0
            let lowMask = (1 << 16) - 1

            let printWidth = 16
            if printing {
                let a = "Gen. A".centered(width: printWidth, filler: "-")
                let b = "Gen. B".centered(width: printWidth, filler: "-")
                print("\(a) \(b)")
            }

            for cycleCount in (0..<cycles) {
                if printing {
                    print("\t\t\t\t\t\tCycle \(cycleCount): \(Date())")
                }

                // generate next values for each generator
                let a = genA.nextValue()
                let b = genB.nextValue()

                if printing {
                    let astr = "\(a)".padded(with: " ", length: printWidth)
                    let bstr = "\(b)".padded(with: " ", length: printWidth)
                    print("\(astr) \(bstr)")
                }

                // compare their lowest 16 bits
                if (a & lowMask) == (b & lowMask) {
                    matches += 1
                }
                /* // slow way
                let ab = String(a, radix: 2).suffix(16)
                let bb = String(b, radix: 2).suffix(16)
                if ab == bb {
                    matches += 1
                }
                 */
            }

            return matches
        }
    }

    // MARK: -

    func defaultInput() -> String? {
        return "277, 349"
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 15: 💥 NO INPUT")
            exit(10)
        }

        let numbers = runInput.split(separator: ",")
                              .map { String($0).trimmed() }
                              .flatMap(Int.init)

        let thing = partOne(input: numbers)
        guard let answer = thing else {
            print("Day 15: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 15: (Part 1) Answer ", answer)

        let thing2 = partTwo(input: numbers)
        guard let answer2 = thing2 else {
            print("Day 15: (Part 2) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 15: (Part 2) Answer ", answer2)
    }

    // MARK: -

    func partOne(input: [Int]) -> Int? {
        guard input.count > 1 else { return nil }
        var judge = Judge(a: input[0], b: input[1])
        let matches = judge.compare(cycles: 40_000_000)
        return matches
    }

    func partTwo(input: [Int]) -> Int? {
        guard input.count > 1 else { return nil }
        var judge = Judge(a: input[0], b: input[1], useMultiples: true)
        let matches = judge.compare(cycles: 5_000_000)
        return matches
    }
}

