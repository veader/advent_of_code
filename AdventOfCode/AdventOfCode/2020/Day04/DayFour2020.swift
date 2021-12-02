//
//  DayFour.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/4/20.
//

import Foundation

struct DayFour2020: AdventDay {
    var year = 2020
    var dayNumber = 4
    var dayTitle = "Passport Processing"
    var stars = 2

    func parse(_ input: String?) -> [Passport] {
        (input ?? "")
            .replacingOccurrences(of: "\n\n", with: "|")
            .split(separator: "|")
            .map(String.init)
            .compactMap { Passport($0) }
    }

    func partOne(input: String?) -> Any {
        let passports = parse(input)
        return passports.filter({ $0.valid }).count
    }

    func partTwo(input: String?) -> Any {
        let passports = parse(input)
        return passports.filter({ $0.fullyValid }).count
    }
}
