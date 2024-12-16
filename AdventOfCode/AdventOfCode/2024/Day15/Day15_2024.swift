//
//  Day15_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/15/24.
//

import Foundation

struct Day15_2024: AdventDay {
    var year = 2024
    var dayNumber = 15
    var dayTitle = "Warehouse Woes"
    var stars = 1

    func parse(_ input: String?) -> WarehouseSimulator {
        WarehouseSimulator(input: input ?? "")
    }

    func partOne(input: String?) async-> Any {
        let warehouse = parse(input)
        warehouse.followMoves()
        return warehouse.boxScore()
    }

    func partTwo(input: String?) async -> Any {
        let warehouse = parse(input)
        return 0
    }
}
