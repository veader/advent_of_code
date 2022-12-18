//
//  DayFifteen2022.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/18/22.
//

import Foundation

struct DayFifteen2022: AdventDay {
    var year = 2022
    var dayNumber = 15
    var dayTitle = "Beacon Exclusion Zone"
    var stars = 1

    func partOne(input: String?) -> Any {
        let bez = BEZ(input ?? "")
        print(bez.pairs)
        let occupiedPoints = bez.occupied(on: 2_000_000)
        return occupiedPoints.count
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}


