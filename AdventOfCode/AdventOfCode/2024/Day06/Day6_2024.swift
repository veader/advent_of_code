//
//  Day6_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/6/24.
//

import Foundation

struct Day6_2024: AdventDay {
    var year = 2024
    var dayNumber = 6
    var dayTitle = "Guard Gallivant"
    var stars = 1

    func parse(_ input: String?) -> GridMap<String> {
        let mapData: [[String]] = (input ?? "").lines().map { $0.map(String.init) }
        return GridMap(items: mapData)
    }

    func createPatrol(_ input: String?) -> GuardPatrol {
        let map = parse(input)
        return GuardPatrol(map: map)
    }

    func partOne(input: String?) -> Any {
        let patrol = createPatrol(input)
        return patrol.followGuard().count
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
