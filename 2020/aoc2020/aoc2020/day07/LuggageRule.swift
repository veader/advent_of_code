//
//  LuggageRule.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/7/20.
//

import Foundation

struct LuggageRule {
    /// Color of the this luggage
    let color: String

    /// Luggage that can contain this luggage type
    let parents: [String]

    /// Luggage contained with this luggage type
    let children: [String: Int]


    /// Does this luggage have parents?
    var hasParents: Bool {
        !parents.isEmpty
    }

    /// Does this luggage have children?
    var hasChildren: Bool {
        !children.isEmpty
    }

    // MARK: - Altering a LuggageRule

    /// Create a new copy of this LuggageRule that contains the added parent
    func adding(parent: String) -> LuggageRule {
        LuggageRule(color: color, parents: (parents + [parent]).unique(), children: children)
    }
}

extension LuggageRule {
    /// Create a LuggageRule with a description.
    ///
    /// Examples:
    ///     - "dotted black bags contain no other bags."
    ///     - "vibrant plum bags contain 5 faded blue bags, 6 dotted black bags."
    init?(_ input: String) {
        guard let separatorRange = input.range(of: "bags contain") else { return nil }

        let pieces = input.replacingCharacters(in: separatorRange, with: "|")
            .split(separator: "|")
            .map(String.init)
            .map { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }

        guard pieces.count == 2, let colorName = pieces.first, let childrenDetails = pieces.last else { return nil }

        color = colorName

        // Parents are set in the LuggageRuleSet when these rules are mixed into a "tree"
        parents = [String]()

        // Children should be contained in the second piece
        if childrenDetails == "no other bags." {
            children = [String: Int]()
        } else {
            let kids = String(childrenDetails.dropLast(1)) // drop the period
                .split(separator: ",")
                .map(String.init)
                .map { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
                .compactMap { (details: String) -> (color: String, count: Int)? in
                    guard
                        let match = details.matching(regex: "^([0-9]+) ([a-z ]+) bag[s]?"),
                        let countString = match.captures.first,
                        let count = Int(countString),
                        let childColor = match.captures.last
                        else { return nil }

                    return (childColor, count)
                }

            var tmpChildren = [String: Int]()
            for kid in kids {
                tmpChildren[kid.color] = kid.count
            }

            children = tmpChildren
        }
    }
}
