//
//  RuleParser.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/19/20.
//

import Foundation

class RuleParser {

    /// Rules that define valid messages
    let rules: [Int: MessageRule]

    /// List of all sample messages
    let messages: [String]

    /// Mapping of rule number to possible values
    var ruleMap = [Int: [String]]()

    init(_ input: String) {
        let lines = input.split(separator: "\n").map(String.init)

        var tmpRules = [Int: MessageRule]()
        var tmpMessages = [String]()

        for line in lines {
            if let rule = MessageRule(line) {
                tmpRules[rule.number] = rule
            } else {
                tmpMessages.append(line)
            }
        }

        rules = tmpRules
        messages = tmpMessages
    }

    func validMessages() -> [String] {
        buildMap()
        let possibleValues = Set(ruleMap[0] ?? [])
        let messagesSet = Set(messages)
        return Array(possibleValues.intersection(messagesSet))
    }

    @discardableResult
    func buildMap() -> [String] {
        messages(from: 0)
    }

    private func messages(from ruleNum: Int) -> [String] {
        guard let rule = rules[ruleNum] else { print("Found no rule for \(ruleNum)"); return [] }

        if let memoChoices = ruleMap[ruleNum] {
            // print("Found memoized possibilities for \(ruleNum)")
            // if we've been here before we know the results...
            return memoChoices
        } else if let letter = rule.letter {
            // print("\(ruleNum) is a LEAF -> \(letter)")
            // hit a leaf node, only a letter on the leaf
            ruleMap[ruleNum] = [letter] // memoize it
            return [letter]
        } else if let subRules = rule.subRules {
            // print("Recursing for \(ruleNum) -> \(subRules)...")
            var fullPossibilities = [String]()
            fullPossibilities = subRules.flatMap { (ruleNums: [Int]) -> [String] in
                // print("SubRule: \(ruleNums) for \(ruleNum)...")
                var possibilities = [String]()
                var numbers = ruleNums

                while !numbers.isEmpty {
                    let num = numbers.removeFirst()
                    let results = messages(from: num)
                    // print("\t -> \(results) -> \(possibilities)")

                    possibilities = results.flatMap { (r: String) -> [String] in
                        if possibilities.isEmpty {
                            return [r]
                        } else {
                            return possibilities.map { "\($0)\(r)" }
                        }
                    }
                    // print("\t Resulting: \(possibilities)")
                }

                return possibilities
            }

            // print("Found \(fullPossibilities.count) for \(ruleNum)")
            ruleMap[ruleNum] = fullPossibilities // memoize it
            return fullPossibilities
        } else {
            print("Problem: Couldn't find anything for rule \(ruleNum)")
            return []
        }
    }
}
