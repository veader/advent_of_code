//
//  LuggageRuleSet.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/7/20.
//

import Foundation

class LuggageRuleSet {

    /// Mapping of luggage colors to their rule
    var rules: [String: LuggageRule]

    /// Create a LuggageRuleSet with a list of luggage rule descriptions
    init(_ input: [String]) {
        rules = [String: LuggageRule]()

        let bagRules = input.compactMap { LuggageRule($0) }
        for bag in bagRules {
            rules[bag.color] = bag
        }

        // interlace the rules - setting parent "links"
        rules.forEach { parentColor, bag in
            // for each child, set a parent reference
            bag.children.forEach { color, _ in
                if var rule = rules[color] {
                    rule = rule.adding(parent: parentColor)
                    rules[color] = rule
                } else {
                    print("Huh: \(parentColor) - \(bag) - \(color)")
                }
            }
        }
    }

    /// Find the parents of the given color
    func parents(of color: String) -> [String] {
        var parents = [String]()

        var rulesToCheck = [LuggageRule]()

        // start search with parents of our given bag color
        if let rule = rules[color] {
            rulesToCheck.append(contentsOf: rule.parents.compactMap({ rules[$0] }))
        }

        while(!rulesToCheck.isEmpty) {
            let rule = rulesToCheck.removeFirst()

            if !parents.contains(rule.color) {
                parents.append(rule.color)
                rulesToCheck.append(contentsOf: rule.parents.compactMap({ rules[$0] }))
            }
        }

        return parents
    }
}
