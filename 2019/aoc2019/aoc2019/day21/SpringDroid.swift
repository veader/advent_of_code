//
//  SpringDroid.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/26/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct SpringDroid {

    enum SpringScript {
        case AND(X: Register, Y: Register) /// set Y to _true_ if X **AND** Y are _true_, _false_ otherwise
        case OR(X: Register, Y: Register)  /// set Y to _true_ if X **OR** Y is _true_, _false_ otherwise
        case NOT(X: Register, Y: Register) /// set Y to _true_ if X is _false_, _true_ otherwise
        case WALK

        func ascii() -> [Int] {
            var string = ""

            switch self {
            case .AND(X: let X, Y: let Y):
                string = "AND \(X.rawValue) \(Y.rawValue)\n"
            case .OR(X: let X, Y: let Y):
                string = "OR \(X.rawValue) \(Y.rawValue)\n"
            case .NOT(X: let X, Y: let Y):
                string = "NOT \(X.rawValue) \(Y.rawValue)\n"
            case .WALK:
                string = "WALK\n"
            }

            return string.map { Int($0.asciiValue ?? 0) }
        }
    }

    enum Register: String, CaseIterable {
        case T = "T" /// temporary
        case J = "J" /// jump - should the droid jump?
        case A = "A" /// ground _one_ tile away
        case B = "B" /// ground _two_ tiles away
        case C = "C" /// ground _three_ tiles away
        case D = "D" /// ground _four_ tiles away
    }

    private let machine: IntCodeMachine
    private var registers: [Register: Bool]

    var instructions: [SpringScript]

    let writeableRegisters: [Register] = [.J, .T]
    let readonlyRegisters: [Register] = [.A, .B, .C, .D]

    init(input: String) {
        machine = IntCodeMachine(instructions: input)
        machine.silent = true

        instructions = [SpringScript]()
        registers = [Register: Bool]()

        // all registers initialize to false
        for register in Register.allCases {
            registers[register] = false
        }
    }

    func run() {
        // input all of the instructions to the machine and run
        let asciiInputs = instructions.flatMap { $0.ascii() }
        print("Machine Inputs: \(asciiInputs)")
        machine.set(inputs: asciiInputs)

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

        let camera = Camera(input: machine.outputs)
        camera.printScreen()
    }
}
