//
//  DaySix.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/6/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DaySix: AdventDay {

    struct Memory {
        /// Size of the memory bank
        let size: Int

        /// Value of the memory banks
        var banks: [Int]

        /// Copy of each previous iteration of memory redistribution
        var previousConfigurations = [[Int]]()

        init(_ seed: [Int]) {
            size = seed.count
            banks = seed
        }

        mutating func redistrubute() -> Int {
            previousConfigurations = [[Int]]() // clear any previous configs

            // loop until we find our current configuration has been seen before
            while !previousConfigurations.contains(where: { $0 == banks }) {
                // print(banks)
                previousConfigurations.append(banks)

                // determine next bank to redistribute
                guard let index = indexToRedistribute() else {
                    print("Unable to determine index.")
                    break
                }

                redistribute(index: index)
            }

            return previousConfigurations.count // -1?
        }

        private func indexToRedistribute() -> Int? {
            let max = banks.max()

            // find all indices that match the max
            let indices = banks.enumerated().flatMap { (idx, blk) -> Int? in
                return blk == max ? idx : nil
            }

            return indices.min()
        }

        /// Redistribute the blocks from a given index.
        private mutating func redistribute(index: Int) {
            // print("\tRedistribute \(index)")

            var blockCount = banks[index]
            var distributionIndex = index + 1
            banks[index] = 0 // remove all blocks from current index

            while blockCount > 0 {
                // spread blocks around the memory banks
                banks[distributionIndex % size] += 1
                blockCount -= 1
                distributionIndex += 1
            }
        }
    }

    // MARK: -

    func defaultInput() -> String? {
        return "5    1    10    0    1    7    13    14    3    12    8    10    7    12    0    6"
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 6: 💥 NO INPUT")
            exit(10)
        }

        let initialMemory = runInput.split(separator: " ").flatMap { str -> String? in
            let cleanedStr = str.replacingOccurrences(of: " ", with: "")
            return cleanedStr.count > 0 ? cleanedStr : nil
        }.flatMap(Int.init)

        let thing = partOne(input: initialMemory)
        guard let answer = thing else {
            print("Day 6: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 6: (Part 1) Answer ", answer)

        let thing2 = partTwo(input: initialMemory)
        guard let answer2 = thing2 else {
            print("Day 6: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 6: (Part 2) Answer ", answer2)
    }

    // MARK: -

    func partOne(input: [Int]) -> Int? {
        var memory = Memory(input)
        return memory.redistrubute()
    }

    func partTwo(input: [Int]) -> Int? {
        var memory = Memory(input)
        _ = memory.redistrubute() // finds the end of the loop
        return memory.redistrubute() // find the length of the loop by going again till we hit the start
    }
}

