//
//  Day9_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/9/23.
//

import Foundation

struct Day9_2023: AdventDay {
    var year = 2023
    var dayNumber = 9
    var dayTitle = "Mirage Maintenance"
    var stars = 1

    struct OasisReading {
        let readings: [Int]

        /// Return the delta of each pair of elements in the array.
        func deltas(of array: [Int]) -> [Int] {
            (0..<(array.count - 1)).map { idx in
                array[idx+1] - array[idx]
            }
        }

        /// Process the reading values to calculate the next entry
        func process(_ array: [Int]? = nil) -> [Int] {
            let array = array ?? readings

            guard !array.allZeros else { return array }

            let arrayPrime = process(deltas(of: array))
            return array + [array[array.count-1] + arrayPrime[arrayPrime.count - 1]]
        }

        /// Parse the given text to create an OasisReading
        static func parse(_ input: String) -> OasisReading {
            let readings = input.split(separator: " ").map(String.init).map { Int($0)! }
            return OasisReading(readings: readings)
        }
    }

    func parse(_ input: String?) -> [OasisReading] {
        (input ?? "").lines().map { OasisReading.parse($0) }
    }

    func partOne(input: String?) -> Any {
        let readings = parse(input)
        let nexts = readings.compactMap {
            let arr = $0.process()
            return arr.last
        }
        assert(readings.count == nexts.count)
        return nexts.reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
