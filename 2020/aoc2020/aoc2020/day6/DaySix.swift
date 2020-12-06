//
//  DaySix.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/6/20.
//

import Foundation

struct DaySix: AdventDay {
    var dayNumber: Int = 6

    func parse(_ input: String?) -> [CustomsForm] {
        (input ?? "")
            .replacingOccurrences(of: "\n\n", with: "|")
            .split(separator: "|")
            .map(String.init)
            .compactMap { CustomsForm($0) }
    }

    func partOne(input: String?) -> Any {
        let forms = parse(input)
        return forms.reduce(0) { $0 + $1.yesQuestions }
    }

    func partTwo(input: String?) -> Any {
        return 1
//        let passwords = parse(input)
//        return passwords.filter({ $0.valid(policyType: .position) }).count
    }
}
