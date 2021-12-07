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
    var stars = 2

    func parse(_ input: String?) -> [Int] {
        (input ?? "").trimmingCharacters(in: .newlines)
                     .split(separator: ",")
                     .map(String.init)
                     .compactMap(Int.init)
    }

    func mode(of array: [Int]) -> Int {
        var hash = [Int: Int]()
        array.forEach { hash.incrementing($0, by: 1)}
        return hash.max(by: { $0.value < $1.value })?.key ?? Int.min
    }

    func median(of array: [Int]) -> Int {
        let midIndex = array.count / 2
        return array.sorted()[midIndex]
    }

    func mean(of array: [Int]) -> Int {
        let answer = Float(array.reduce(0, +)) / Float(array.count)
        print("MEAN: \(answer) | \(round(answer)) | \(Int(round(answer)))")
        return Int(round(answer))
    }


    func calculcateCost(destination: Int, positions: [Int], constantCost: Bool = true) -> Int {
        return positions.reduce(0) { cost, pos in
            let distance = abs(pos - destination)
            if constantCost {
                return cost + distance
            } else {
                return cost + (0...distance).reduce(0, +)
            }
        }
    }

    func partOne(input: String?) -> Any {
        let crabPositions = parse(input)
        let mode = mode(of: crabPositions)
        let median = median(of: crabPositions)

        let modeCost = calculcateCost(destination: mode, positions: crabPositions)
        print("Mode: \(modeCost) (\(mode))")
        let medianCost = calculcateCost(destination: median, positions: crabPositions)
        print("Median: \(medianCost) (\(median))")

        return [modeCost, medianCost].min() ?? Int.max
    }

    func partTwo(input: String?) -> Any {
        let crabPositions = parse(input)

        let mode = mode(of: crabPositions)
        let modeCost = calculcateCost(destination: mode, positions: crabPositions, constantCost: false)
        print("Mode: \(modeCost) (\(mode))")

        let median = median(of: crabPositions)
        let medianCost = calculcateCost(destination: median, positions: crabPositions, constantCost: false)
        print("Median: \(medianCost) (\(median))")

        let mean = mean(of: crabPositions)
        let meanCost = calculcateCost(destination: mean, positions: crabPositions, constantCost: false)
        print("Mean: \(meanCost) (\(mean))")
        let delta = 1
        let meanCostAbove = calculcateCost(destination: mean+delta, positions: crabPositions, constantCost: false)
        print("Mean (above): \(meanCostAbove) (\(mean+delta))")
        let meanCostBelow = calculcateCost(destination: mean-delta, positions: crabPositions, constantCost: false)
        print("Mean (below): \(meanCostBelow) (\(mean-delta))")

        return [modeCost, medianCost, meanCost, meanCostAbove, meanCostBelow].min() ?? Int.max
    }
}
