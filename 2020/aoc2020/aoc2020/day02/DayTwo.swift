//
//  DayTwo.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/2/20.
//

import Foundation

struct DayTwo: AdventDay {
    var dayNumber: Int = 2

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
