//
//  Day10.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/10/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DayTen: AdventDay {

    struct KnotHash {
        var string: [Int]
        var lengths: [Int]
        var currentIndex = 0
        var skipSize = 0

        init?(_ input: String, length stringLength: Int = 256, useASCII: Bool = false) {
            string = Array(0..<stringLength)

            if useASCII {
                let salt = [17, 31, 73, 47, 23]
                lengths = input.unicodeScalars.map { Int($0.value) } + salt
            } else {
                lengths = input.replacingOccurrences(of: " ", with: "")
                               .split(separator: ",")
                               .map(String.init)
                               .flatMap(Int.init)
            }
        }

        mutating func run(rounds: Int = 64) -> String {
            for _ in 0..<rounds {
                hash()
            }

            let denseHash = calculateDenseHash()
            let hashValue = denseHash.map { value -> String in
                var hexed = String(value, radix: 16)
                while hexed.count < 2 {
                    hexed = "0" + hexed
                } // pad with 0 prefixs

                return hexed
            }.joined()

            return hashValue
        }

        mutating func hash() {
            for length in lengths {
                // printState(length: length)

                // reverse length of string and twist
                let endIndex = currentIndex + length

                // print("...Twisting...")

                if endIndex > string.count {
                    // length wraps around

                    // range at end of string
                    let endRange = currentIndex..<string.count
                    // range for wrapping piece to beginning of string
                    let beginningRange = 0..<(endIndex % string.count)

                    // create twist out of both pieces
                    var twist = Array((string[endRange] + string[beginningRange]).reversed())

                    // split them apart and put them back
                    let endTwist = twist[0..<endRange.count]
                    string.replaceSubrange(endRange, with: endTwist)

                    let startTwist = twist[endRange.count...]
                    string.replaceSubrange(beginningRange, with: startTwist)
                } else { // not wrapping
                    let range = currentIndex..<endIndex
                    let twist = string[range].reversed()
                    string.replaceSubrange(range, with: twist)
                }

                // printState(length: length)
                // print("-------------------------")

                // adjust current position by length
                currentIndex = (currentIndex + length + skipSize) % string.count
                skipSize += 1
            }
        }

        private func calculateDenseHash() -> [Int] {
            let sliceSize = 16
            let sliceCount = string.count / sliceSize
            var slices = [[Int]]()

            for sliceNum in 0..<sliceCount {
                let sliceIndex = sliceNum * sliceSize
                let sliceEndIndex = min(sliceIndex + sliceSize, string.count)
                let slice = Array(string[sliceIndex..<sliceEndIndex])
                slices.append(slice)
            }

            return slices.map { $0.reduce(0, ^) }
        }

        func printState(length: Int) {
            let output = string.enumerated().map { idx, value -> String in
                var out = ""

                if idx == currentIndex {
                    out += "([\(value)]"
                } else {
                    out += "\(value)"
                }

                if idx == (currentIndex + length - 1) % string.count {
                    out += ")"
                }

                return out
            }.joined(separator: ", ")

            print(output)
        }
    }

    // MARK: -

    func defaultInput() -> String? {
        return "120,93,0,90,5,80,129,74,1,165,204,255,254,2,50,113"
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 10: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 10: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 10: (Part 1) Answer ", answer)

        let thing2 = partTwo(input: runInput)
        guard let answer2 = thing2 else {
            print("Day 10: (Part 2) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 10: (Part 2) Answer ", answer2)
    }

    // MARK: -

    func partOne(input: String, count: Int = 256) -> Int? {
        guard var hash = KnotHash(input, length: count) else { return nil }
        hash.hash()

        return (hash.string[0]) * (hash.string[1])
    }

    func partTwo(input: String, count: Int = 256) -> String? {
        guard var hash = KnotHash(input, length: count, useASCII: true) else { return nil }
        return hash.run(rounds: 64)
    }
}
