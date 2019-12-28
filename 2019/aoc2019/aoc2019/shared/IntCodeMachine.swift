//
//  IntCodeMachine.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/2/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

class IntCodeMachine {
    enum State {
        case halted  /// no instructions have been run
        case running /// started running an instruction
        case awaitingInput /// machine stopped waiting for input
        case finished(output: Int) /// machine finished with last output
        case error
    }

    // MARK: - Properties

    /// Internal (protected) memory used when running the machine
    private var internalMemory: [Int]

    /// Contents of memory (read only) for external use.
    var memory: [Int] {
        get { return internalMemory }
    }

    /// Memory used when accessing outside of the original memory space.
    /// Stored with address as the key.
    private var overflowMemory: [Int: Int]

    /// Location (in memory space) of the current instruction
    var instructionPointer: Int

    /// Collection of inputs to use as required.
    /// If no inputs are found, the machine will sit waiting for input.
    var inputs: [Int] = [Int]()

    /// Collections of outputs given over the course of the machine's run.
    var outputs: [Int] = [Int]()

    /// Relative base used for instructions in relative mode.
    var relativeBase: Int = 0

    /// Should extra information be printed for debugging?
    var debug: Bool = false

    /// Avoid all output, including OUTPUT data.
    var silent: Bool = false

    /// Current state of this machine.
    var state: IntCodeMachine.State = .halted {
        didSet {
            if case .running = self.state {
                runloop()
            }
        }
    }


    // MARK: - Inits
    init(memory: [Int]) {
        instructionPointer = 0
        overflowMemory = [Int: Int]()
        internalMemory = memory
    }

    init(instructions: String) {
        instructionPointer = 0
        overflowMemory = [Int: Int]()
        internalMemory = IntCodeMachine.parse(instructions: instructions)
    }


    // MARK: - Static Methods
    static func parse(instructions: String) -> [Int] {
        return instructions
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .split(separator: ",")
                .compactMap { Int($0) }
    }


    // MARK: - Public Methods
    func run() {
        state = .running
    }

    /// Run the next
    func runNextInstruction() {
        // read instruction
        let instruction = currentInstruction()

        printDebug("+==================================================================")
        printDebug("| Running step: Position: \(instructionPointer)")
        printDebug("| Instruction: \(instruction)")
        printDebug("| Memory Size: \(memory.count)")
        printDebug("| Overflow Memory: \(overflowMemory)")
        printDebug("| Relative Base: \(relativeBase)")
            // print(memory)

        // terminate at the end or bogus instruction
        guard
            instruction.opcode != .unknownInstruction,
            instruction.opcode != .terminate
            else {
                state = .finished(output: outputs.last ?? 0)
                return
            }

        printDebug("| Mem Slice: \(memory[instructionPointer..<(instructionPointer + instruction.offset)])")

        var movedPointer = false

        switch instruction.opcode {
        case .add:
            let value1 = value(for: instruction.parameters[0])
            let value2 = value(for: instruction.parameters[1])
            let storeAddr = address(for: instruction.parameters[2])

            store(value: value1 + value2, at: storeAddr)
        case .multiply:
            let value1 = value(for: instruction.parameters[0])
            let value2 = value(for: instruction.parameters[1])
            let storeAddr = address(for: instruction.parameters[2])

            store(value: value1 * value2, at: storeAddr)
        case .input:
            guard let input = gatherInput() else {
                // stop processing and leave the machine in current configuration
                state = .awaitingInput
                return
            }

            let storeAddr = address(for: instruction.parameters[0])
            store(value: input, at: storeAddr)
        case .output:
            let outputValue = value(for: instruction.parameters[0])
            outputs.append(outputValue)
            if !silent {
                print("OUTPUT: \(outputValue)")
            }
        case .jumpIfTrue, .jumpIfFalse:
            let value1 = value(for: instruction.parameters[0])
            let value2 = value(for: instruction.parameters[1])

            if case .jumpIfTrue = instruction.opcode, value1 != 0 {
                printDebug("Jumping to \(value2)")
                instructionPointer = value2
                movedPointer = true
            } else if case .jumpIfFalse = instruction.opcode, value1 == 0 {
                printDebug("Jumping to \(value2)")
                instructionPointer = value2
                movedPointer = true
            }
        case .lessThan, .equals:
            let value1 = value(for: instruction.parameters[0])
            let value2 = value(for: instruction.parameters[1])
            let storeAddr = address(for: instruction.parameters[2])

            if case .lessThan = instruction.opcode, value1 < value2 {
                store(value: 1, at: storeAddr)
            } else if case .equals = instruction.opcode, value1 == value2 {
                store(value: 1, at: storeAddr)
            } else {
                store(value: 0, at: storeAddr)
            }
        case .adjustRelativeBase:
            let value1 = value(for: instruction.parameters[0])
            printDebug("Adjusting relative base: from \(relativeBase) to \(relativeBase + value1)")
            relativeBase += value1
        case .terminate, .error:
            break // nothing to do here
        case .unknownInstruction:
            print("Unknown: \(instruction)")
        }

        // move to next instruction
        if !movedPointer {
            instructionPointer = instructionPointer + instruction.offset
        }
    }

    /// What is the memory value at a given location?
    /// - parameters:
    ///     - position: Memory location
    /// - returns: Value of memory location. `-1` for negative address
    func memory(at position: Int) -> Int {
        guard position >= 0 else {
            printDebug("ERROR: Attempted to read from address \(position)")
            return -1
        }

        if internalMemory.indices.contains(position) {
            printDebug("Read \(internalMemory[position]) from address: \(position)")
            return internalMemory[position]
        } else if overflowMemory.keys.contains(position) {
            printDebug("Read \(overflowMemory[position] ?? 0) from address: \(position)")
            return overflowMemory[position] ?? 0
        }

        return 0 // assume uninitialized memory
    }

    /// Store a value into the machine's memory at a given position.
    /// - parameters:
    ///     - value: Value to store in memory
    ///     - position: Memory location
    func store(value: Int, at position: Int) {
        printDebug("Storing \(value) at address: \(position)")
        guard position >= 0 else {
            printDebug("ERROR: Attempted to store to address \(position)")
            return
        }

        if internalMemory.indices.contains(position) {
            internalMemory[position] = value
        } else {
            overflowMemory[position] = value
        }
    }

    /// Give input to the machine.
    /// If the machine is waiting for input, it will continue to run again.
    /// - parameters:
    ///     - input: Input to give to the machine
    func set(input: Int) {
        set(inputs: [input])
    }

    /// Give a series of inputs to the machine at once.
    /// If the machine is waiting for input, it will continue to run again.
    /// - parameters:
    ///     - inputs: A collection of inputs to give the machine
    func set(inputs newInputs: [Int]) {
        inputs.append(contentsOf: newInputs)

        // if the machine is awaiting input, kick it off again
        if case .awaitingInput = state {
            state = .running
        }
    }

    /// Attempts to reset the machine.
    /// Instruction pointer, relative base, and outputs reset.
    /// - warning: The memory is not reset, use with caution
    func reset() {
        instructionPointer = 0
        relativeBase = 0
        outputs = [Int]()
        state = .halted
    }


    // MARK: - Private Methods
    private func runloop() {
        while case .running = self.state {
            runNextInstruction()
        }
    }

    private func address(for param: IntCodeInstruction.OpCodeParam) -> Int {
        switch param {
        case .position(offset: let offset):
            // in position mode, memory location needs to be dereferenced when used
            return memory(at: instructionPointer + offset)
        case .immediate(offset: let offset):
            return instructionPointer + offset
        case .relative(offset: let offset):
            // in relative mode, the contents of this memory location should be used in conjunction with relativeBase
            return memory(at: instructionPointer + offset) + relativeBase
        }
    }

    private func value(for param: IntCodeInstruction.OpCodeParam) -> Int {
        let addr = address(for: param)
        switch param {
        case .position(offset: _):
            return memory(at: addr)
        case .immediate(offset: _):
            return memory(at: addr)
        case .relative(offset: _):
            return memory(at: addr)
        }
    }

    private func gatherInput() -> Int? {
        guard !inputs.isEmpty else { return nil }
        return inputs.removeFirst()
    }

    private func currentInstruction() -> IntCodeInstruction {
        // TODO: can the instruction pointer move into overflow memory?

        guard
            memory.indices.contains(instructionPointer)
            else { return IntCodeInstruction(opcode: .unknownInstruction) }

        return IntCodeInstruction(input: memory[instructionPointer])
    }

    private func printDebug(_ output: String) {
        if debug && !silent {
            print(output)
        }
    }
}
