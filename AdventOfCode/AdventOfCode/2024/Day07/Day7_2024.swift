//
//  Day7_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/7/24.
//

import Foundation

struct Day7_2024: AdventDay {
    var year = 2024
    var dayNumber = 7
    var dayTitle = "Bridge Repair"
    var stars = 2

    func parse(_ input: String?) -> [CalibrationEquation] {
        (input ?? "").lines().compactMap(CalibrationEquation.init)
    }

    func partOne(input: String?) -> Any {
        let equations = parse(input)

        return equations.filter { eq in
            eq.searchForValidOperations().count > 0
        }.reduce(0) { acc, eq in
            acc + eq.result
        }
    }

    func partTwo(input: String?) -> Any {
        let equations = parse(input)

        return equations.filter { eq in
            eq.searchForValidOperations(useConcatenation: true).count > 0
        }.reduce(0) { acc, eq in
            acc + eq.result
        }
    }
}
