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
    var stars = 0

    func partOne(input: String?) -> Any {
        let algo = HillClimbingAlgo(input ?? "")
        let path = algo.climb()
        return path?.count ?? 0
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
