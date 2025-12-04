//
//  Day3_2025.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/3/25.
//

import Foundation

struct Day3_2025: AdventDay {
    var year = 2025
    var dayNumber = 3
    var dayTitle = "Lobby"
    var stars = 1

    func parse(_ input: String?) -> [[Int]] {
        (input ?? "").lines().compactMap { line in
            line.trimmingCharacters(in: .whitespacesAndNewlines)
                .split(separator: "")
                .map(String.init)
                .compactMap(Int.init)
        }
    }

    func partOne(input: String?) -> Any {
        let batteryBanks = parse(input)
        return batteryBanks.reduce(into: 0) { result, bank in
            result += findMaxBatteryPair(bank)
        }
    }

    func partTwo(input: String?) -> Any {
        let batteryBanks = parse(input)
        return 0
    }

    func findMaxBatteryPair(_ bank: [Int]) -> Int {
        var pair: [Int] = []
        var maxJoltage = 0
        var idx = 0 // start at the beginning

        while idx < (bank.count - 1) {
            defer { idx += 1 }

            let batt1 = bank[idx]

            // can't find another number pair that starts with a lower number
            guard batt1 >= (pair.first ?? 0) else { continue }

            let theRest = bank.suffix(from: idx+1)
            let batt2 = theRest.max() ?? 0
            let newJoltage = Int("\(batt1)\(batt2)") ?? 0

            if newJoltage > maxJoltage {
                pair = [batt1, batt2]
                maxJoltage = newJoltage
            }
        }

        return maxJoltage
    }
}
