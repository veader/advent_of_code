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
        let key: String
        var blocks: [[Int]] // two dimensional array

        init(_ input: String, size: Int = 128) {
            key = input

            let diskBlocks = (0..<size).map { row -> [Int] in
                let knotInput = "\(input)-\(row)"

                if var knotHash  = KnotHash(knotInput, length: 256, useASCII: true) {
                    let hash = knotHash.run()
                    if let binary = hash.hexAsBinary() {
                        return binary.map { $0 == "0" ? 0 : 1 }
                    }
                }

                print("Unable to create knot hash for \(knotInput)")
                return Array(repeatElement(0, count: size))
            }

            blocks = diskBlocks
        }

        func freeSpace() -> Int {
            let allBlocks = blocks.count * (blocks.first?.count ?? 128)
            return allBlocks - usedSpace()
        }

        func usedSpace() -> Int {
            return blocks.map { row -> Int in
                return row.reduce(0, +)
            }.reduce(0, +)
        }

        func printState() {
            for row in blocks {
                let rowString = row.map { $0 == 0 ? "." : "#" }.joined()
                print(rowString)
            }
        }
    }


    // MARK: -

    func defaultInput() -> String? {
        return "ffayrhll"
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
        let disk = Disk(input)
        return disk.usedSpace()
    }

    func partTwo(input: String) -> Int? {
        return nil
    }
}
