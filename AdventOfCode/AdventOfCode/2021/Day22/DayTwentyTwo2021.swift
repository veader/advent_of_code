//
//  DayTwentyTwo2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/27/21.
//

import Foundation

struct DayTwentyTwo2021: AdventDay {
    var year = 2021
    var dayNumber = 22
    var dayTitle = "Reactor Reboot"
    var stars = 1

    func parse(_ input: String?) -> [CuboidInstruction] {
        (input ?? "").split(separator: "\n").map(String.init).compactMap { CuboidInstruction.parse($0) }
    }

    func partOne(input: String?) -> Any {
        let instructions = parse(input)
        let grid = CuboidGrid(instructions: instructions)
        grid.run()
        return grid.cubesOn.count
    }

    func partTwo(input: String?) -> Any {
        return Int.min
    }
}
