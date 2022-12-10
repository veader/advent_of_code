//
//  DayTen2022.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/10/22.
//

import Foundation

struct DayTen2022: AdventDay {
    var year = 2022
    var dayNumber = 10
    var dayTitle = "Cathode-Ray Tube"
    var stars = 1

    func partOne(input: String?) -> Any {
        let cpu = SimpleCPU(input ?? "")
        cpu.run()

        let answers = [20, 60, 100, 140, 180, 220].map { cycle in
            cpu.value(during: cycle) * cycle
        }
        return answers.reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
