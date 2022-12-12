//
//  MonkeySim.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/11/22.
//

import Foundation
import RegexBuilder

class MonkeySim {

    /// Monkeys in the simulator.
    var monkeys: [Monkey]

    init(monkeys: [Monkey]) {
        self.monkeys = monkeys.sorted(by: { $0.index < $1.index }) // just in case...
    }

    func run(rounds: Int = -1, divide: Bool = true) {
        var round = 0
        while rounds == -1 || round < rounds {
            for monkey in monkeys {
                handle(monkey: monkey, divide: divide)
            }

            round += 1

            if round % 1000 == 0 {
                printInspections(round: round)
            }
        }
    }

    func printInspections(round: Int) {
        print("== After round \(round) ==")
        for monkey in monkeys {
            print("Monkey \(monkey.index) inspected items \(monkey.inspectionCount) times.")
        }
    }

    func handle(monkey: Monkey, divide: Bool = true) {
        for item in monkey.items {
            var newItem = monkey.update(item: item)
            if divide {
                newItem /= 3 // divide by 3
            }

            if monkey.test(item: newItem) {
                monkeys[monkey.testTrueIndex].items.append(newItem)
            } else {
                monkeys[monkey.testFalseIndex].items.append(newItem)
            }

            monkey.inspectionCount += 1
        }

        // clear items...
        monkey.items = []
    }

    static func parse(_ input: String) -> [Monkey] {
        input.matches(of: monkeyRegex).compactMap { match -> Monkey? in
            guard
                let index = Int(match.1),
                let op = Monkey.OperationOperator(rawValue: String(match.3)),
                let opInput = Monkey.OperationInput(String(match.4)),
                let testValue = Int(match.5),
                let testTrue = Int(match.6),
                let testFalse = Int(match.7)
            else { return nil }

            let items = String(match.2).split(separator: ", ").map(String.init).compactMap(UInt.init)

            return Monkey(index: index, items: items, operation: op, opInput: opInput, testValue: testValue, trueIndex: testTrue, falseIndex: testFalse)
        }
    }

    // MARK: - Monkey

    class Monkey {
        enum OperationOperator: String, Equatable {
            case add = "+"
            case subtract = "-"
            case multiply = "*"
        }

        enum OperationInput: Equatable {
            case old
            case digit(Int)

            init?(_ input: String) {
                if input == "old" {
                    self = .old
                } else if let amount = Int(input) {
                    self = .digit(amount)
                } else {
                    return nil
                }
            }
        }

        let index: Int
        var items: [UInt]

        let op: OperationOperator
        let opInput: OperationInput

        let testValue: Int

        let testTrueIndex: Int
        let testFalseIndex: Int

        var inspectionCount: Int = 0

        init(index: Int, items: [UInt], operation: OperationOperator, opInput: OperationInput, testValue: Int, trueIndex: Int, falseIndex: Int) {
            self.index = index
            self.items = items

            self.op = operation
            self.opInput = opInput

            self.testValue = testValue
            self.testTrueIndex = trueIndex
            self.testFalseIndex = falseIndex
        }

        /// Test the given "item" and determine where the monkey will throw.
        func test(item: UInt) -> Bool {
            item % UInt(testValue) == 0
        }

        /// Update the given "item" based on the rules for the monkey.
        func update(item: UInt) -> UInt {
            var input = item // default to "old"
            if case .digit(let amount) = opInput {
                input = UInt(amount)
            }

            switch op {
            case .add:
                return item + input
            case .subtract:
                return item - input
            case .multiply:
                return item * input
            }
        }
    }

    /// Regex to match the following:
    /// Monkey 1:
    ///     Starting items: 57, 95, 80, 92, 57, 78
    ///     Operation: new = old * 13
    ///     Test: divisible by 2
    ///       If true: throw to monkey 2
    ///       If false: throw to monkey 6
    static let monkeyRegex = Regex {
        // ---- First line: "Monkey 0:"
        "Monkey "
        Capture {
            OneOrMore(.digit)
        }
        ":"
        One(.newlineSequence)

        // ---- Second Line: "\tStarting items: 98, 89, 52"
        OneOrMore(.whitespace)
        "Starting items: "
        Capture {
            OneOrMore(/\d*,?\s?/) // comma separated list of numbers
        }
        One(.newlineSequence)

        // ---- Third Line: "\tOperation: new = old * 2" or "new = old + old"
        OneOrMore(.whitespace)
        "Operation: new = old "
        Capture {
            ChoiceOf {
                "*"
                "+"
                "-"
            }
        }
        One(.whitespace)
        Capture {
            ChoiceOf {
                OneOrMore(.digit)
                "old"
            }
        }
        One(.newlineSequence)

        // ---- Fourth Line: "\tTest: divisible by 5"'
        OneOrMore(.whitespace)
        "Test: divisible by "
        Capture {
            OneOrMore(.digit)
        }
        One(.newlineSequence)

        // ---- Fifth & Sixth Line: "\t\tIf true: throw to monkey 6"
        monkeyTestRegex
        monkeyTestRegex

        // Blank line between instances...
        Optionally {
            One(.newlineSequence)
        }
    }

    static let monkeyTestRegex = Regex {
        OneOrMore(.whitespace)
        "If "
        ChoiceOf {
            "true"
            "false"
        }
        ": throw to monkey "
        Capture {
            OneOrMore(.digit)
        }
        Optionally {
            One(.newlineSequence)
        }
    }
}
