//
//  MessageRule.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/19/20.
//

import Foundation

struct MessageRule {
    /// Name/number of the rule
    let number: Int

    /// Raw string of the rule
    let ruleText: String

    /// List of sub-rules including any "OR" style rules
    let subRules: [[Int]]?

    /// Final letter if the rule is a final letter
    let letter: String?

    init?(_ input: String) {
        let pieces = input.split(separator: ":").map(String.init).map { $0.trimmingCharacters(in: .whitespaces) }
        guard pieces.count == 2, let num = Int(pieces[0]) else { return nil }

        ruleText = input
        number = num

        let ruleDetails = pieces[1]

        if ruleDetails.contains("\"") {
            letter = pieces[1].replacingOccurrences(of: "\"", with: "")
            subRules = nil
        } else {
            let subRuleDetails = ruleDetails
                .split(separator: "|")
                .map(String.init)
                .map { $0.trimmingCharacters(in: .whitespaces) }

            subRules = subRuleDetails.map {
                $0.split(separator: " ").map(String.init).compactMap(Int.init)
            }
            letter = nil
        }
    }
}
