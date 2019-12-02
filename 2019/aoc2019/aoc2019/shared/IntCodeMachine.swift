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

        /// Offset to jump to reach the next instruction
        var offset: Int {
            switch self {
            case .add, .multiply:
                return 4
            default:
                return 1
            }
        }

        /// Offsets for each parameter for this instruction
        var parameters: [Int] {
            switch self {
            case .add, .multiply:
                return [1,2,3]
            default:
                return []
            }
        }
    }

    private var internalMemory: [Int]
    var memory: [Int] {
        get { return internalMemory }
    }
    var instructionPointer: Int
    var debug: Bool = false

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
        // read instruction
        let instruction = currentInstruction()

        if debug {
            print("Running step: Position: \(instructionPointer)")
            print(memory)
            print("Instruction: \(instruction)")
        }

        // terminate at the end or bogus instruction
        guard
            instruction != .unknownInstruction,
            instruction != .terminate
            else { return instruction }

        // read values into the heap
        let heap = instruction.parameters.map { memory(at: instructionPointer + $0) }

        switch instruction {
        case .add:
            store(value: memory(at: heap[0]) + memory(at: heap[1]), at: heap[2])
        case .multiply:
            store(value: memory(at: heap[0]) * memory(at: heap[1]), at: heap[2])
        default:
            print("This shouldn't be here... \(instruction)")
        }

        // move to next instruction
        instructionPointer = instructionPointer + instruction.offset

        return instruction
    }

    func currentInstruction() -> IntCodeInstruction {
        guard
            memory.indices.contains(instructionPointer),
            let instruction = IntCodeInstruction(rawValue: memory[instructionPointer])
            else { return .unknownInstruction }

        return instruction
    }

    func memory(at position: Int) -> Int {
        guard internalMemory.indices.contains(position) else { return -1 }
        return internalMemory[position]
    }

    mutating func store(value: Int, at position: Int) {
        guard internalMemory.indices.contains(position) else { return }
        internalMemory[position] = value
    }
}

extension IntCodeMachine {
    init(memory: [Int]) {
        instructionPointer = 0
        self.internalMemory = memory
    }
}
