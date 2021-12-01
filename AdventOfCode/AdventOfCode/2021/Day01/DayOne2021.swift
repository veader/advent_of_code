//
//  DayOne2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/1/21.
//

import Foundation

struct DayOne2021: AdventDay {
    var year = 2021
    var dayNumber = 1
    var dayTitle = "Sonar Sweep"
    var stars = 2

    func parse(_ input: String?) -> [Int] {
        (input ?? "").split(separator: "\n").compactMap { Int($0) }
    }

    func partOne(input: String?) -> Any {
        let depths = parse(input)

        var depthIncreases = 0
        var lastDepth: Int?
        depths.forEach { depth in
            if let lastDepth = lastDepth, depth > lastDepth {
                depthIncreases += 1
            }
            lastDepth = depth
        }

        return depthIncreases
    }

    func partTwo(input: String?) -> Any {
        let depths = parse(input)

        // compute sliding windows
        var slidingWindows = [Int]()
        depths.indices.forEach { idx in
            guard idx + 2 < depths.count else { return }

            let window = [
                depths[idx],
                depths[idx+1],
                depths[idx+2],
            ].reduce(0, +)
            slidingWindows.append(window)
        }

        var depthIncreases = 0
        var lastWindow: Int?
        slidingWindows.forEach { window in
            if let lastWindow = lastWindow, window > lastWindow {
                depthIncreases += 1
            }
            lastWindow = window
        }

        return depthIncreases
    }
}
