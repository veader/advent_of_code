//
//  DayEighteen.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/18/20.
//

import Foundation

struct DayEighteen2020: AdventDay {
    var year = 2020
    var dayNumber = 18
    var dayTitle = "Operation Order"
    var stars = 1

    func parse(_ input: String?) -> [String] {
        (input ?? "").split(separator: "\n").map(String.init)
    }

    func partOne(input: String?) -> Any {
        let lines = parse(input)
        let answers = lines.map { MathEquation($0).solve() }
        return answers.reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        return -1
    }
}
