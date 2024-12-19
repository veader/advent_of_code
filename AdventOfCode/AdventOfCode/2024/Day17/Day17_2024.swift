//
//  Day17_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/19/24.
//

import Foundation

struct Day17_2024: AdventDay {
    var year = 2024
    var dayNumber = 17
    var dayTitle = "Chronospatial Computer"
    var stars = 1

    func parse(_ input: String?) -> Chronoputer {
        return Chronoputer(input: input ?? "")
    }

    func partOne(input: String?) async-> Any {
        let cpu = parse(input)
        cpu.execute()
        return cpu.output.map(String.init).joined(separator: ",")
    }

    func partTwo(input: String?) async -> Any {
        let cpu = parse(input)
        var aValue = 0

        while cpu.output != cpu.instructions {
            aValue += 1 // try the next number
            
            cpu.reset()
            cpu.registerA = aValue
            cpu.execute()
        }

        return aValue
    }
}
