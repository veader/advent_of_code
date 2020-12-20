//
//  DayNineteen.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/19/20.
//

import Foundation

struct DayNineteen: AdventDay {
    var dayNumber: Int = 19

    func partOne(input: String?) -> Any {
        let parser = RuleParser(input ?? "")
        let valid = parser.validMessages()
        // print(valid)
        return valid.count
    }

    func partTwo(input: String?) -> Any {
        return -1
    }
}
