//
//  IntCodeMachine.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/2/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct IntCodeMachine {
    enum State {
        case halted  /// no instructions have been run
        case running /// started running an instruction
        case awaitingInput /// machine stopped waiting for input
        case finished(output: Int) /// machine finished with last output
        case error
    }

    // MARK: - Properties
    private var internalMemory: [Int]
    var memory: [Int] {
        get { return internalMemory }
    }

    var instructionPointer: Int
    var inputs = [Int]()
    var outputs = [Int]()

    var state: IntCodeMachine.State = .halted {
        didSet {
            if case .running = self.state {
                runloop()
            }
        }
    }

    var debug: Bool = false


    // MARK: - Static Methods
    static func parse(instructions: String) -> [Int] {
        return instructions
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .split(separator: ",")
                .compactMap { Int($0) }
    }


    // MARK: - Public Methods
    mutating func run() {
        state = .running
    }

    /// Run the next
    mutating func runNextInstruction() {
        // read instruction
        let instruction = currentInstruction()

        if debug {
            print("+==================================================================")
            print("| Running step: Position: \(instructionPointer)")
            // print(memory)
            print("| Instruction: \(instruction)")
        }

        // terminate at the end or bogus instruction
        guard
            instruction.opcode != .unknownInstruction,
            instruction.opcode != .terminate
            else {
                state = .finished(output: outputs.last ?? 0)
                return
            }

        // read values into the heap
        let heap = instruction.parameters.map { param -> Int in
            switch param {
            case .position(offset: let offset):
                // in position mode, memory location needs to be dereferenced when used
                return memory(at: instructionPointer + offset)
                // return memory(at: memAddress)
            case .immediate(offset: let offset):
                return memory(at: instructionPointer + offset)
            }
        }

        var movedPointer = false

        switch instruction.opcode {
        case .add:
            let value1 = value(at: 0, heap: heap, params: instruction.parameters)
            let value2 = value(at: 1, heap: heap, params: instruction.parameters)

            store(value: value1 + value2, at: heap[2])
        case .multiply:
            let value1 = value(at: 0, heap: heap, params: instruction.parameters)
            let value2 = value(at: 1, heap: heap, params: instruction.parameters)

            store(value: value1 * value2, at: heap[2])
        case .input:
            guard let input = gatherInput() else {
                // stop processing and leave the machine in current configuration
                state = .awaitingInput
                return
            }
            store(value: input, at: heap[0])
        case .output:
            let outputValue = value(at: 0, heap: heap, params: instruction.parameters)
            outputs.append(outputValue)
            print("OUTPUT: \(outputValue)")
        case .jumpIfTrue, .jumpIfFalse:
            let value1 = value(at: 0, heap: heap, params: instruction.parameters)
            let value2 = value(at: 1, heap: heap, params: instruction.parameters)

            if case .jumpIfTrue = instruction.opcode, value1 != 0 {
                instructionPointer = value2
                movedPointer = true
            } else if case .jumpIfFalse = instruction.opcode, value1 == 0 {
                instructionPointer = value2
                movedPointer = true
            }
        case .lessThan, .equals:
            let value1 = value(at: 0, heap: heap, params: instruction.parameters)
            let value2 = value(at: 1, heap: heap, params: instruction.parameters)

            if case .lessThan = instruction.opcode, value1 < value2 {
                store(value: 1, at: heap[2])
            } else if case .equals = instruction.opcode, value1 == value2 {
                store(value: 1, at: heap[2])
            } else {
                store(value: 0, at: heap[2])
            }
        default:
            print("This shouldn't be here... \(instruction)")
        }

        // move to next instruction
        if !movedPointer {
            instructionPointer = instructionPointer + instruction.offset
        }
    }

    /// What is the memory value at a given location?
    /// - parameters:
    ///     - position: Memory location
    /// - returns: Value of memory location. `-1` on unknown location
    func memory(at position: Int) -> Int {
        guard internalMemory.indices.contains(position) else { return -1 }
        return internalMemory[position]
    }

    /// Store a value into the machine's memory at a given position.
    /// - parameters:
    ///     - value: Value to store in memory
    ///     - position: Memory location
    mutating func store(value: Int, at position: Int) {
        guard internalMemory.indices.contains(position) else { return }
        internalMemory[position] = value
    }

    /// Give input to the machine.
    /// If the machine is waiting for input, it will continue to run again.
    /// - parameters:
    ///     - input: Input to give to the machine
    mutating func set(input: Int) {
        inputs.append(input)

        // if the machine is awaiting input, kick it off again
        if case .awaitingInput = state {
            state = .running
        }
    }


    // MARK: - Private Methods
    private mutating func runloop() {
        while case .running = self.state {
            runNextInstruction()
        }
    }

    private func value(at index: Int, heap: [Int], params: [IntCodeInstruction.OpCodeParam]) -> Int {
        var value = heap[index]
        if case .position(offset: _) = params[index] {
            value = memory(at: value)
        }

        return value
    }

    private mutating func gatherInput() -> Int? {
        guard !inputs.isEmpty else { return nil }
        return inputs.removeFirst()
    }

    private func currentInstruction() -> IntCodeInstruction {
        guard
            memory.indices.contains(instructionPointer)
            else { return IntCodeInstruction(opcode: .unknownInstruction) }

        return IntCodeInstruction(input: memory[instructionPointer])
    }
}

// MARK: - Init Extension
extension IntCodeMachine {
    init(memory: [Int]) {
        instructionPointer = 0
        self.internalMemory = memory
    }

    init(instructions: String) {
        instructionPointer = 0
        internalMemory = IntCodeMachine.parse(instructions: instructions)
    }
}
