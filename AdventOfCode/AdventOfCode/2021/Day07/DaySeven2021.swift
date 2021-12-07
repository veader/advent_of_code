//
//  DaySeven2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/7/21.
//

import Foundation

struct DaySeven2021: AdventDay {
    var year = 2021
    var dayNumber = 7
    var dayTitle = "The Treachery of Whales"
    var stars = 1

    func parse(_ input: String?) -> [Int] {
        (input ?? "").trimmingCharacters(in: .newlines)
                     .split(separator: ",")
                     .map(String.init)
                     .compactMap(Int.init)
    }

    func mode(of array: [Int]) -> Int {
        var hash = [Int: Int]()
        array.forEach { hash.incrementing($0, by: 1)}
        print(hash)
        return hash.max(by: { $0.value < $1.value })?.key ?? Int.min
    }

    func median(of array: [Int]) -> Int {
        let midIndex = array.count / 2
        return array.sorted()[midIndex] ?? Int.min
    }


    func calculcateCost(destination: Int, positions: [Int]) -> Int {
        return positions.reduce(0) { cost, pos in
            cost + (abs(pos - destination))
        }
    }

    func partOne(input: String?) -> Any {
        let crabPositions = parse(input)
        let mode = mode(of: crabPositions)
        let median = median(of: crabPositions)

        // the mode gives us a decent starting point to search
        let modeCost = calculcateCost(destination: mode, positions: crabPositions)
        print("Mode: \(modeCost) (\(mode))")
        let medianCost = calculcateCost(destination: median, positions: crabPositions)
        print("Median: \(medianCost) (\(median))")

        return [modeCost, medianCost].min() ?? Int.max
    }

    func partTwo(input: String?) -> Any {
        Int.min
    }
}
