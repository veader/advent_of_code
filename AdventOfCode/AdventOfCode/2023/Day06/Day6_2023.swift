//
//  Day6_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/6/23.
//

import Foundation
import RegexBuilder

struct Day6_2023: AdventDay {
    var year = 2023
    var dayNumber = 6
    var dayTitle = "Wait For It"
    var stars = 1

    func parse(_ input: String?) -> (times: [Int]?, distances: [Int]?) {
        var times: [Int]?
        var distances: [Int]?

        let lines = (input ?? "").split(separator: "\n").map(String.init)
        for line in lines {
            let values = line.split(separator: " ").map(String.init).compactMap(Int.init)
            
            if let _ = line.firstMatch(of: /^Time:\s/) {
                times = values
            } else if let _ = line.firstMatch(of: /^Distance:\s/) {
                distances = values
            }
        }

        return (times, distances)
    }

    func calculate(for time: Int, beating distance: Int) -> [Int] {
        (1..<time).map({ (time - $0) * $0 }).filter { $0 > distance }
    }

    func partOne(input: String?) -> Any {
        let (times, distances) = parse(input)
        guard let times, let distances, times.count == distances.count else { return 0 }

        var counts: [Int] = []
        for (idx, time) in times.enumerated() {
            let possible = calculate(for: time, beating: distances[idx])
            counts.append(possible.count)
        }

        return counts.reduce(1, *)
    }

    func partTwo(input: String?) -> Any {
        return 0
    }

}
