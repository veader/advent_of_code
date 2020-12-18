//
//  DayEighteen.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/18/20.
//

import Foundation

struct DayEighteen: AdventDay {
    var dayNumber: Int = 18

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
