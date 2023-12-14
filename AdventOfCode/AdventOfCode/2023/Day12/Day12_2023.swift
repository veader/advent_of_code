//
//  Day12_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/12/23.
//

import Foundation
import RegexBuilder

struct Day12_2023: AdventDay {
    var year = 2023
    var dayNumber = 12
    var dayTitle = "Hot Springs"
    var stars = 0

    enum SpringType: String, CustomDebugStringConvertible {
        case operational = "."
        case damaged = "#"
        case unknown = "?"

        var debugDescription: String { rawValue }
    }

    struct SpringMap {
        let springs: [SpringType]
        let springCounts: [Int]

        func findArrangements() -> Int {
            // split the springs by operational ones (.)
            // for each part, see how many numbers it can "handle"
            // ie: `?#?#` could handle `1,1` or `2,1` or `4` or `3` etc...
            // probably some interesting matches for greatest value it can handle or looking at known parts
            // for each "part", create new SpringMap and call this same method on it
            // multiply the answers together?
            
            if springs.contains(where: { $0 == .operational }) {
                // find all the chunks that have broken or unknown springs
                let parts = springs.split(separator: .operational)
                print(parts)

                // for the chunk, if it has any broken (#) it must have at least 1 number, but possibly others
            } else {
                print("No operational in \(springs)! Calculating...")
            }
            return 0
        }

        static func parse(_ input: String) -> SpringMap? {
            guard let match = input.firstMatch(of: /^([\.#\?]+)\s+([\d\,?]+)/) else {
                return nil
            }

            let springs = String(match.output.1).charSplit().compactMap { SpringType(rawValue: $0) }
            let counts = String(match.output.2).split(separator: ",").map(String.init).compactMap(Int.init)

            return SpringMap(springs: springs, springCounts: counts)
        }
    }

    func parse(_ input: String?) -> [SpringMap] {
        (input ?? "").lines().compactMap { SpringMap.parse($0) }
    }

    func partOne(input: String?) -> Any {
        return 1
    }

    func partTwo(input: String?) -> Any {
        return 1
    }
}
