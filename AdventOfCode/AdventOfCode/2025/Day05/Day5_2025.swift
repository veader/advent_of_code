//
//  Day5_2025.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/5/25.
//

import Foundation

struct Day5_2025: AdventDay {
    var year = 2025
    var dayNumber = 5
    var dayTitle = "Cafeteria"
    var stars = 1

    func parse(_ input: String?) -> ([ClosedRange<Int>], [Int]) {
        var ranges = [ClosedRange<Int>]()
        var available = [Int]()

        for line in (input ?? "").lines() {
            let parts = line.split(separator: "-")
            if parts.count == 2, let start = Int(parts[0]), let end = Int(parts[1]) {
                ranges.append(start...end)
            } else if parts.count == 1, let id = Int(parts[0]) {
                available.append(id)
            }
        }

        return (ranges, available)
    }

    func partOne(input: String?) -> Any {
        let (ranges, available) = parse(input)
        let fresh = available.filter { id in
            guard let range = ranges.first(where: { $0.contains(id) }) else { return false }
            return true
        }

        return fresh.count
    }

    func partTwo(input: String?) -> Any {
        let (ranges, available) = parse(input)
        return 0
    }
}
