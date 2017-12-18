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

        mutating func nextValue() -> Int {
            let value = (previous * factor) % divisor
            previous = value
            return value
        }
    }

    struct Judge {
        var genA: Generator
        var genB: Generator

        init(a: Int, b: Int) {
            genA = Generator(factor: 16807, previous: a)
            genB = Generator(factor: 48271, previous: b)
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

            for _ in (0..<cycles) {
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

        // ...
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
        return nil
    }
}

