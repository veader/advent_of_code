//
//  VacuumRobot.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/26/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct VacuumRobot {
    let machine: IntCodeMachine
    lazy var camera: Camera = {
        Camera(input: machine.outputs)
    }()

    init(input: String) {
        machine = IntCodeMachine(instructions: input)
        machine.silent = true
    }

    func wakeUp() {
        machine.store(value: 2, at: 0)
    }

    func run() {
        var finished = false

        // start the machine running
        machine.run()

        while !finished {
            if case .finished(output: _) = machine.state {
                finished = true
            } else if case .awaitingInput = machine.state {
                print("Awaiting input")
                finished = true
            }
        }
    }
}
