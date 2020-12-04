//
//  DayFour.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/4/20.
//

import Foundation

struct DayFour: AdventDay {
    var dayNumber: Int = 4

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
