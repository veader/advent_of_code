//
//  DayTwelve2022.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/12/22.
//

import Foundation

struct DayTwelve2022: AdventDay {
    var year = 2022
    var dayNumber = 12
    var dayTitle = "Hill Climbing Algorithm"
    var stars = 2

    func partOne(input: String?) -> Any {
        let algo = HillClimbingAlgo(input ?? "")
        let path = algo.climb()

        var count = path.count
        if path.last == algo.end {
            count -= 1
        }

        return count
    }

    func partTwo(input: String?) -> Any {
        let algo = HillClimbingAlgo(input ?? "")
        guard let path = algo.shortestRoute() else { return -1 }

        var count = path.count
        if path.last == algo.end {
            count -= 1
        }

        return count
    }
}
