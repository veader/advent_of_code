//
//  DayFive.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/5/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DayFive: AdventDay {
    var dayNumber: Int = 5

    func parse(_ input: String?) -> [Int] {
        return (input ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: ",")
            .compactMap { Int($0) }
    }

    func partOne(input: String?) -> Any {
        let memory = parse(input)
        var machine = IntCodeMachine(memory: memory)
        machine.inputs = [1]

        machine.run()

        return machine.outputs.last ?? 0
    }

    func partTwo(input: String?) -> Any {
        let memory = parse(input)
        var machine = IntCodeMachine(memory: memory)
        machine.inputs = [5]

        machine.run()

        // return machine.memory(at: 0)
        return machine.outputs.last ?? 0
    }
}
