//
//  DayThree.swift
//  AdventOfCode2018
//
//  Created by Shawn Veader on 12/3/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import Foundation

struct DayThree: AdventDay {

    public struct Coordinate: Hashable {
        let x: Int
        let y: Int
    }

    public struct SuitCloth: CustomDebugStringConvertible {

        var width: Int = 1000
        var height: Int = 1000

        var claimedSquares = [Coordinate: String]()

        init() {
            width = 1000
            height = 1000
        }

        init(width: Int, height: Int) {
            self.width = width
            self.height = height
        }

        func isValid(coordinate: Coordinate) -> Bool {
            return  (0..<width).contains(coordinate.x) &&
                    (0..<height).contains(coordinate.y)
        }

        subscript(coordinate: Coordinate) -> String {
            get {
                assert(isValid(coordinate: coordinate), "Coordinate out of range")
                return claimedSquares[coordinate] ?? "."
            }
            set {
                assert(isValid(coordinate: coordinate), "Coordinate out of range")
                claimedSquares[coordinate] = newValue
            }
        }

        mutating func markClaim(to claim: SuitClothClaim) {
            let yRange = claim.coordinate.y..<(claim.coordinate.y + claim.height)
            let xRange = claim.coordinate.x..<(claim.coordinate.x + claim.width)
            for y in yRange {
                for x in xRange {
                    let c = Coordinate(x: x, y: y)
                    switch self[c] {
                    case "o": // already claimed by just one
                        self[c] = "X" // mark collision
                    case "X": // already claimed by multiple
                        break // do nothing
                    default:  // not claimed, mark the first
                        self[c] = "o"
                    }
                }
            }
        }

        var debugDescription: String {
            var cloth: String = ""
            for y in (0..<height) {
                var row: String = ""
                for x in (0..<width) {
                    row.append(self[Coordinate(x: x, y: y)])
                }
                cloth.append("\(row)\n")
            }
            return cloth
        }
    }

    public struct SuitClothClaim {
        let stringRepresentation: String
        let claimID: Int
        let coordinate: Coordinate
        let width: Int
        let height: Int

        init?(input: String) {
            // input should be of the following format: #1 @ 1,3: 4x4
            guard let regex = try? NSRegularExpression(pattern: "\\#([0-9]+) \\@ ([0-9]+),([0-9]+)\\: ([0-9]+)x([0-9]+)", options: .caseInsensitive)
                else { return nil }

            let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: input.count))
            guard let match = matches.first else { return nil }

            var captures = [String]()

            for index in 0..<match.numberOfRanges {
                let range = match.range(at: index)
                captures.append((input as NSString).substring(with: range))
            }

            guard captures.count == 6 else { return nil }

            stringRepresentation = input
            // the 0 index is the whole string that matches
            guard
                let theID = Int(captures[1]),
                let x = Int(captures[2]),
                let y = Int(captures[3]),
                let theWidth = Int(captures[4]),
                let theHeight = Int(captures[5])
                else { return nil }

            claimID = theID
            coordinate = Coordinate(x: x, y: y)
            width = theWidth
            height = theHeight
        }
    }

    var dayNumber: Int = 3

    @discardableResult func run(_ input: String? = nil, _ part: Int? = 1) -> Any {
        guard let input = input ?? defaultInput else {
            print("Day \(dayNumber): NO INPUT")
            exit(10)
        }

        if part == 1 {
            let checksum = partOne(input: input)
            print("Day \(dayNumber) Part \(part!): Final Answer \(checksum)")
            return checksum
//        } else {
//            let matchingChars = partTwo(input: input)
//            print("Day \(dayNumber) Part \(part!): Final Answer \(matchingChars)")
//            return matchingChars
        }

        return ""
    }

    func partOne(input: String) -> Int {
        let claims = input.split(separator: "\n")
                          .map(String.init)
                          .compactMap { SuitClothClaim(input: $0) }

        var cloth = SuitCloth()

        for claim in claims {
            cloth.markClaim(to: claim)
        }

        // find all collision areas
        var count = 0
        for square in cloth.claimedSquares {
            if square.value == "X" {
                count += 1
            }
        }
        
        return count
    }

    func partTwo(input: String) -> String {
        // let boxIDs = input.split(separator: "\n").map(String.init)
        return ""
    }
}
