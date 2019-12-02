//
//  DayTwo.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/2/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DayTwo: AdventDay {
    var dayNumber: Int = 2

    @discardableResult func run(_ input: String? = nil, _ part: Int? = 1) -> Any {
        guard let input = input ?? defaultInput else {
            print("Day \(dayNumber): NO INPUT")
            exit(10)
        }

        let memory = input.trimmingCharacters(in: .whitespacesAndNewlines)
                          .split(separator: ",")
                          .compactMap { Int($0) }

        if part == 1 {
            let answer = partOne(input: memory)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        } else {
            let answer = partTwo(input: memory)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        }
    }

    func partOne(input: [Int]) -> Int {
        var machine = IntCodeMachine(memory: input)

        // alter values at 1 and 2
        machine.store(value: 12, at: 1)
        machine.store(value: 2, at: 2)

        machine.run()

        return machine.memory(at: 0)
    }

    func partTwo(input: [Int]) -> Int {
        var machine: IntCodeMachine
        let searchResult = 19690720
        let range = 0...99

        // hack: brute force
        for noun in range {
            for verb in range {
                machine = IntCodeMachine(memory: input)

                // alter noun and range
                machine.store(value: noun, at: 1)
                machine.store(value: verb, at: 2)

                machine.run()

                let result = machine.memory(at: 0)

                if result == searchResult {
                    let answerString = "\(String(format: "%02d", noun))\(String(format: "%02d", verb))"
                    return Int(answerString) ?? 0
//                } else {
//                    print("Noun: \(noun) Verb: \(verb) Result: \(result)")
                }
            }
        }

        return 0
    }
}
