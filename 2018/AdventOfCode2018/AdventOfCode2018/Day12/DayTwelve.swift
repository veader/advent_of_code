//
//  DayTwelve.swift
//  AdventOfCode2018
//
//  Created by Shawn Veader on 12/13/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import Foundation

struct DayTwelve: AdventDay {
    var dayNumber: Int = 12

    struct PotInfo {
        let startingCondition: String
        let growthRules: [String: Bool]
    }

    struct PlantGeneration {
        let initial: String
        let zeroIndex: Int
        let plantMap: [Int: Bool]

        init(initial: String, zeroIndex: Int = 0) {
            self.initial = initial
            self.zeroIndex = zeroIndex

            var mapping = [Int: Bool]()
            for (idx, char) in initial.enumerated() {
                if char == "#" { // only record where the plants are
                    mapping[idx - zeroIndex] = true
                }
            }
            self.plantMap = mapping
        }

        func sum() -> Int {
            return plantMap.keys.reduce(0, +)
        }

        /// Given a center index, return the sequence string that represents
        ///     subsequence in the LLCRR format. (left left center right right)
        func subSequence(center: Int) -> String {
            return ((center - 2)...(center + 2))
                        .map { plantMap[$0] ?? false }
                        .reduce("", { result, hasPlant in
                            return result + (hasPlant ? "#" : ".")
                        })
        }

        func nextGeneration(given rules: [String: Bool]) -> (generation: String, zeroIndex: Int)? {
            var min = (plantMap.keys.min() ?? 0) - 2
            let max = (plantMap.keys.max() ?? 0) + 2

            // it's just easier if the min isn't more than 0...
            if min > 0 {
                min = 0
            }

            var next = ""
            for idx in (min...max) {
                let sub = subSequence(center: idx)
                if let plantGrows = rules[sub] {
                    next += plantGrows ? "#" : "."
                } else {
                    // print("No match for \(sub)")
                    next += "."
                }
            }

            return (generation: next, zeroIndex: 0 - min)
        }

        func printable(start: Int = 0, to length: Int? = nil) -> String {
            var max: Int = 0
            if let length = length {
                max = length
            } else {
                max = (plantMap.keys.max() ?? 0) + 2 // one past the last plant
            }
            let minIdx = plantMap.keys.min() ?? 0

            var realStart = [start, minIdx].min() ?? start
            if realStart > 0 { // don't allow the start to be above 0... just makes life easier
                realStart = 0
            }

            var output = ""
            for i in (realStart..<max) {
                output += (plantMap[i] ?? false) ? "#" : "."
            }
            return output
        }
    }

    @discardableResult func run(_ input: String? = nil, _ part: Int? = 1) -> Any {
        guard let input = input ?? defaultInput else {
            print("Day \(dayNumber): NO INPUT")
            exit(10)
        }

        guard let plantInfo = parse(input: input) else {
            print("Day \(dayNumber): Problem parsing input")
            exit(11)
        }

        if part == 1 {
            let answer = partOne(info: plantInfo)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        } else {
            return 0
//            let answer = partTwo(tree: tree)
//            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
//            return answer
        }
    }

    func partOne(info: PotInfo) -> Int {
        let firstGeneration = PlantGeneration(initial: info.startingCondition)

        var currentGeneration = firstGeneration
        var generationCount = 0
        print("[\(generationCount)] \(currentGeneration.printable()) : 0 : \(currentGeneration.sum())")

        repeat {
            guard let nextGen = currentGeneration.nextGeneration(given: info.growthRules) else {
                print("Problem generating next generation: \(generationCount)")
                break
            }
            currentGeneration = PlantGeneration(initial: nextGen.generation, zeroIndex: nextGen.zeroIndex)
            generationCount += 1
            print("[\(generationCount)] \(currentGeneration.printable()) : \(nextGen.zeroIndex) : \(currentGeneration.sum())")
        } while generationCount < 20

        return currentGeneration.sum()
    }

    /*
     func partTwo(tree: LicenseTree) -> Int {
     guard let rootNode = tree.rootNode else { return Int.min }
     return sumNodeValue(for: rootNode)
     }
     */

    func parse(input: String) -> PotInfo? {
        var lines = input.split(separator: "\n")
                         .map(String.init)
                         .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        let starting = lines.removeFirst().split(separator: ":")
            .map(String.init)
            .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
            .last

        guard let startingPositions = starting else { return nil }

        var rules = [String: Bool]()
        for line in lines {
            let pieces = line.split(separator: " ").map(String.init).map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

            guard
                pieces.count == 3,
                let rule = pieces.first
                else { return nil }

            let grows = pieces.last == "#"
            rules[rule] = grows
        }

        return PotInfo(startingCondition: startingPositions, growthRules: rules)
    }
}
