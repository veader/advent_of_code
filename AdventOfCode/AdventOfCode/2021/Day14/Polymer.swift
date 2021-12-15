//
//  Polymer.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/14/21.
//

import Foundation

class Polymer {
    struct InsertionPair {
        let match: [String]
        let insertion: String

        static func parse(_ input: String) -> InsertionPair? {
            // https://rubular.com/r/Ucf0EvNmHKiJWU
            let ruleRegEx = "^(\\w{2}) -> (\\w)$"
            guard let match = input.matching(regex: ruleRegEx), match.captures.count == 2 else { return nil }

            let pair = match.captures[0]
            let insert = match.captures[1]

            return InsertionPair(match: pair.map(String.init), insertion: insert)
        }
    }

    let template: [String]
    var current: [String]
    let rules: [InsertionPair]

    init(template: String, rules: [InsertionPair]) {
        self.template = template.map(String.init)
        self.rules = rules
        self.current = [String]()
    }

    func run(steps: Int = 10, debugPrint: Bool = false) {
        current = template // start with the template
        if debugPrint {
            print("Template:\t\(current.joined())")
        }

        (0..<steps).forEach { i in
            print("Starting run \(i+1) @ \(Date())")
            processRules(debugPrint: debugPrint)
            if debugPrint {
                print("After step \(i+1):\t\(current.joined())")
            }
            print("\tEnd run \(i+1) @ \(Date())")
        }
    }

    private func processRules(debugPrint: Bool = false) {
        let newPolymer = current.enumerated().flatMap { idx, char -> [String] in
            guard idx + 1 < current.count else { return [char] } // not a pair left

            let nextChar = current[idx+1]
            let pair = [char, nextChar]

            if debugPrint {
                print("\tConsidering \(pair)")
            }

            guard let match = rules.first(where: { $0.match == pair }) else {
                if debugPrint {
                    print("\t\tNo matching rule for \(pair)")
                }
                return [char]
            }

            if debugPrint {
                print("\t\tMatch: \(match)")
            }

            return [char, match.insertion]
        }
        current = newPolymer
    }

    func histogram() -> [String: Int] {
        current.joined().histogram()
    }

    static func parse(_ input: String) -> Polymer {
        var lines = input.split(separator: "\n").map(String.init)
        let template = lines.removeFirst()
        let rules = lines.compactMap { InsertionPair.parse($0) }
        return Polymer(template: template, rules: rules)
    }
}
