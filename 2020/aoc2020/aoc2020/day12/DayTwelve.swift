//
//  DayTwelve.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/13/20.
//

import Foundation

struct DayTwelve: AdventDay {
    var dayNumber: Int = 12

    func parse(_ input: String?) -> [NavInstruction]? {
        input?.split(separator: "\n").map(String.init).compactMap { NavInstruction($0) }
    }

    func partOne(input: String?) -> Any {
        guard let navInstructions = parse(input) else { return -1 }
        let ferry = Ferry(instructions: navInstructions)
        ferry.navigate()
        return ferry.distanceToOrigin()
    }

    func partTwo(input: String?) -> Any {
        return 1
    }
}
