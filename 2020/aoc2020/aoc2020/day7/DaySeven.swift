//
//  DaySeven.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/7/20.
//

import Foundation

struct DaySeven: AdventDay {
    var dayNumber: Int = 7

    func parse(_ input: String?) -> [String] {
        (input ?? "").split(separator: "\n").map(String.init)
    }

    func partOne(input: String?) -> Any {
        let ruleSet = LuggageRuleSet(parse(input))
        let parents = ruleSet.parents(of: "shiny gold")
        return parents.count
    }

    func partTwo(input: String?) -> Any {
        let ruleSet = LuggageRuleSet(parse(input))
        return ruleSet.childBagCount(of: "shiny gold")
    }
}
