//
//  IntCodeMachine.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/2/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct IntCodeMachine {
    enum IntCodeInstruction: Int {
        case add = 1
        case multiply = 2
        case terminate = 99

        // the following are error cases
        case error = -1
        case unknownInstruction = -2
    }

    var ints: [Int]
    var currentPosition: Int

    mutating func run() {
        var stepResult = runStep()
        while stepResult != .terminate {
            stepResult = runStep()
            if stepResult == .error {
                print("Found an error running step... Exiting!")
                stepResult = .terminate
            } else if stepResult == .unknownInstruction {
                print("Unknown instruction found... Exiting!")
                stepResult = .terminate
            }
        }
    }

    mutating func runStep() -> IntCodeInstruction {
        print("Running step: Position: \(currentPosition)")
        print(ints)

        // attempt to gather our instruction
        guard
            ints.indices.contains(currentPosition),
            let instruction = IntCodeInstruction(rawValue: ints[currentPosition])
            else { return .unknownInstruction }

        print("Instruction: \(instruction)")

        // terminate at the end
        guard instruction != .terminate else { return instruction }

        // read values
        let value1Position = int(at: currentPosition + 1)
        let value2Position = int(at: currentPosition + 2)
        let destinationPosition = int(at: currentPosition + 3)

        let value1 = int(at: value1Position)
        let value2 = int(at: value2Position)

        switch instruction {
        case .add:
            print("Adding: \(value1) + \(value2)")
            store(int: value1 + value2, at: destinationPosition)
        case .multiply:
            print("Multiplying: \(value1) * \(value2)")
            store(int: value1 * value2, at: destinationPosition)
        default:
            print("This shouldn't be here... \(instruction)")
        }

        // move to new position
        currentPosition = currentPosition + 4

        return instruction
    }

    func int(at position: Int) -> Int {
        guard ints.indices.contains(position) else { return -1 }
        return ints[position]
    }

    mutating func store(int value: Int, at position: Int) {
        guard ints.indices.contains(position) else { return }
        ints[position] = value
    }
}

extension IntCodeMachine {
    init(input: [Int]) {
        currentPosition = 0
        ints = input
    }
}
