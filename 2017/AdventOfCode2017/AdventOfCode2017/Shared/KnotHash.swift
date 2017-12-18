//
//  KnotHash.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/15/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct KnotHash {
    var string: [Int]
    var lengths: [Int]
    var currentIndex = 0
    var skipSize = 0

    init?(_ input: String, length stringLength: Int = 256, useASCII: Bool = false, salt: [Int] = [17, 31, 73, 47, 23]) {
        string = Array(0..<stringLength)

        if useASCII {
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
