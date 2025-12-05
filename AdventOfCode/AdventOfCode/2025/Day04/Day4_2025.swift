//
//  Day4_2025.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/4/25.
//

import Foundation

struct Day4_2025: AdventDay {
    var year = 2025
    var dayNumber = 4
    var dayTitle = "Printing Department"
    var stars = 1

    enum PaperItem: String {
        case roll = "@"
        case empty = "."
    }

    func parse(_ input: String?) -> GridMap<PaperItem> {
        let mapData: [[PaperItem]] = (input ?? "").lines().map { line in
            line.map(String.init).compactMap { PaperItem(rawValue: $0) }
        }
        return GridMap(items: mapData)
    }
    
    func partOne(input: String?) -> Any {
        let map = parse(input)

        let accessibleRolls = map.filter { coordinate, item in
            guard item == .roll else { return false }

            let adjacent = map.adjacentCoordinates(to: coordinate, allowDiagonals: true)
            let adjacentRolls = adjacent.filter { map.item(at: $0) == .roll }
            return adjacentRolls.count < 4
        }

        return accessibleRolls.count
    }
    
    func partTwo(input: String?) async -> Any {
        //let batteryBanks = parse(input)
        return 0
    }
}
