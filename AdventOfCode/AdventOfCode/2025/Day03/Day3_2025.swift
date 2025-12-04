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
    var stars = 2

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

    func partTwo(input: String?) async -> Any {
        // withTaskGroup <- porcess each battery at the same time
        let batteryBanks = parse(input)

        return batteryBanks.reduce(into: 0) { result, bank in
            result += findMaxJoltage(bank, size: 12)
        }

//        let answers = await withTaskGroup(of: Int.self, returning: [Int].self) { group in
//            for bank in batteryBanks {
//                group.addTask {
//                    await searchBatteries(bank: bank)
//                }
//            }
//
//            var bankAnswers = [Int]()
//            for await result in group {
//                bankAnswers.append(result)
//            }
//            return bankAnswers
//        }
//        return answers.reduce(0, +)
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

    func findMaxJoltage(_ bank: [Int], size: Int) -> Int {
        var selected: [Int] = []
        var remainder = size
        var idx = 0

        while remainder != 0 {
            defer { remainder -= 1 }

            var max = -1
            var maxIdx = -1

            // search range is from our current index (after last selection) to the "end"
            // the "end" is defined as close to the end but still having enough choices to fill the selection
            let range = idx...(bank.count - remainder)
            for i in range {
                guard bank[i] > max else { continue }
                max = bank[i]
                maxIdx = i
            }

            // record our "selection"
            selected.append(max)
            idx = maxIdx + 1
        }

        return joltage(for: selected, size: size)
    }

    /// Create a "joltage" from a given set of numbers. Pad with 0s to reach size...
    func joltage(for batteries: [Int], size: Int) -> Int {
        let nums = batteries + Array(repeating: 0, count: size - batteries.count)
        let str = nums.map(String.init).joined()
        return Int(str) ?? 0
    }

    /// Do a search over the battery bank finding a selection of individual battery cells
    /// that when activated (_selected_) create the largest number of the given length.
    func searchBatteries(bank: [Int], size: Int = 12, index: Int = 0, selected: [Int] = []) async -> Int {
        if selected.count >= size {
            // we've got something large enough, create answer
            return Int(selected.map(String.init).joined()) ?? 0
        }
        guard index < bank.count else { return 0 } // we've gone off the end

        let task = Task { () -> Int in
            [
                // what if we select this battery?
                await searchBatteries(bank: bank, size: size, index: index + 1, selected: selected + [bank[index]]),
                // what if we don't select this battery?
                await searchBatteries(bank: bank, size: size, index: index + 1, selected: selected)
            ].max() ?? 0
        }
        return await task.value
    }
}
