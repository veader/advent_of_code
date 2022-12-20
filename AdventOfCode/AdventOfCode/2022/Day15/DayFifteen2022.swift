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
    var stars = 2

    func partOne(input: String?) -> Any {
        let bez = BEZ(input ?? "")
        let occupiedPoints = bez.occupied(on: 2_000_000)
        return occupiedPoints.count
    }

    func partTwo(input: String?) -> Any {
        let bez = BEZ(input ?? "")
        guard let coordinate = bez.search() else { return 0 }
        let frequency = (coordinate.x * 4_000_000) + coordinate.y
        return frequency
    }
}


