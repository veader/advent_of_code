//
//  DayNineteen.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/19/20.
//

import Foundation

struct DayNineteen2020: AdventDay {
    var year = 2020
    var dayNumber = 19
    var dayTitle = "Monster Messages"
    var stars = 1

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
