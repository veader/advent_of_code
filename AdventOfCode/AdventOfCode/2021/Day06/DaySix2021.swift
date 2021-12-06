//
//  DaySix2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/6/21.
//

import Foundation

struct DaySix2021: AdventDay {
    var year = 2021
    var dayNumber = 6
    var dayTitle = "Lanternfish"
    var stars = 1

    func parse(_ input: String?) -> [Int] {
        (input ?? "").trimmingCharacters(in: .newlines)
                     .split(separator: ",")
                     .map(String.init)
                     .compactMap(Int.init)
    }

    func model(days: Int, fish: [Int], debugPrints: Bool = false) -> [Int] {
        var finalFish = fish
        (0..<days).forEach { d in
            if debugPrints {
                if d == 0 {
                    print("Initial state: (\(finalFish.count)) - \(finalFish.map(String.init).joined(separator: ","))")
                } else {
                    print("After \(d) days: (\(finalFish.count)) - \(finalFish.map(String.init).joined(separator: ","))")
                }
            }

            var appendedFishCount = 0
            finalFish = finalFish.map { f in
                if f == 0 {
                    appendedFishCount += 1
                    return 6
                } else {
                    return f - 1
                }
            }
            finalFish.append(contentsOf: Array(repeating: 8, count: appendedFishCount))
        }

        return finalFish
    }

    func partOne(input: String?) -> Any {
        let fish = parse(input)
        let finalFish = model(days: 80, fish: fish)
        return finalFish.count
    }

    func partTwo(input: String?) -> Any {
        return Int.min
    }
}
