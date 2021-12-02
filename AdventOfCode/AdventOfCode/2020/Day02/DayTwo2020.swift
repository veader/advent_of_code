//
//  DayTwo.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/2/20.
//

import Foundation

struct DayTwo2020: AdventDay {
    var year = 2020
    var dayNumber = 2
    var dayTitle = "Password Philosophy"
    var stars = 2

    func parse(_ input: String?) -> [SamplePassword] {
        (input ?? "").split(separator: "\n").map(String.init).compactMap { SamplePassword($0) }
    }

    func partOne(input: String?) -> Any {
        let passwords = parse(input)
        return passwords.filter({ $0.valid() }).count
    }

    func partTwo(input: String?) -> Any {
        let passwords = parse(input)
        return passwords.filter({ $0.valid(policyType: .position) }).count
    }
}
