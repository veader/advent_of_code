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
    var stars = 2

    func parse(_ input: String?) -> [Int] {
        (input ?? "").trimmingCharacters(in: .newlines)
                     .split(separator: ",")
                     .map(String.init)
                     .compactMap(Int.init)
    }

    func model(days: Int, fish: [Int], debugPrints: Bool = false) -> Int {
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

        return finalFish.count
    }

    func betterModeling(days: Int, fish: [Int], debugPrints: Bool = false) -> Int {
        var buckets = [Int: Int]()
        fish.forEach { buckets.incrementing($0, by: 1) }

        (0..<days).forEach { d in
            if debugPrints {
                print("After \(d) days: \(buckets.values.reduce(0, +))")
            }

            var updatedBuckets = [Int: Int]()
            buckets.forEach { time, count in
                if time == 0 {
                    // add fish
                    updatedBuckets.incrementing(8, by: count)
                    // reset ourselves in the 6 bucket
                    updatedBuckets.incrementing(6, by: count)
                } else {
                    // set ourselves in the next time down bucket
                    updatedBuckets.incrementing((time - 1), by: count)
                }
            }

            buckets = updatedBuckets
        }

        return buckets.values.reduce(0, +)
    }

    func partOne(input: String?) -> Any {
        let fish = parse(input)
        // let finalFishCount = model(days: 80, fish: fish)
        let finalFishCount = betterModeling(days: 80, fish: fish)
        return finalFishCount
    }

    func partTwo(input: String?) -> Any {
        let fish = parse(input)
        let finalFishCount = betterModeling(days: 256, fish: fish)
        return finalFishCount
    }
}
