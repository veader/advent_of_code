//
//  DayNine.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/9/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DayNine: AdventDay {
    var dayNumber: Int = 9

    // func parse(_ input: String?) -> FOO { return FOO... }

    func partOne(input: String?) -> Any {
        let machine = IntCodeMachine(instructions: input ?? "")
        machine.inputs = [1]
        machine.run()

        return machine.outputs.last ?? 0
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
