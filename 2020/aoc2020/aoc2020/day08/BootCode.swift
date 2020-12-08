//
//  BootCode.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/8/20.
//

import Foundation

enum BootInstruction {
    case noop(value: Int)
    case accumulate(value: Int)
    case jump(value: Int)

    init?(rawValue: String) {
        let pieces = rawValue.split(separator: " ")

        guard
            pieces.count == 2,
            let name = pieces.first,
            let valueStr = pieces.last,
            let value = Int(valueStr)
            else { return nil }

        switch name {
        case "nop":
            self = .noop(value: value)
        case "acc":
            self = .accumulate(value: value)
        case "jmp":
            self = .jump(value: value)
        default:
            return nil
        }
    }
}

class BootCode {

    /// List of instructions for this boot code
    var instructions: [BootInstruction]

    /// Current instruction index
    var currentIndex: Int = 0

    /// Accumulator value
    var accumulator: Int = 0

    /// The index of each instruction that has been run
    private var runInstructionIndices: [Int] = [Int]()


    // MARK: - Init

    /// Initialize the boot code with a list of instructions
    init(_ input: [String]) {
        instructions = input.compactMap { BootInstruction(rawValue: $0) }
    }


    // MARK: -

    /// Reset the boot code to initial state
    func reset() {
        currentIndex = 0
        accumulator = 0
        runInstructionIndices = [Int]()
    }

    /// Start the boot code process
    ///
    /// - Parameters:
    ///     - callback: Block that is called after each instruction is executed.
    func run(_ callback: (() -> ())? = nil) {
        reset() // start from the beginning...

        while instructions.indices.contains(currentIndex) {
            runInstructionIndices.append(currentIndex)
            execute(instruction: instructions[currentIndex])
            callback?()
        }
    }

    /// Execute the given instruction.
    ///
    /// - Note: Alters currentIndex during execution.
    func execute(instruction: BootInstruction?) {
        guard let instruction = instruction else { return }

        debug(instruction: instruction)

        switch instruction {
        case .noop(value: _):
            currentIndex += 1 // do nothing and proceed to next instruction
        case .accumulate(value: let value):
            accumulator += value // adjust the accumulator value
            currentIndex += 1 // proceed to next instruction
        case .jump(value: let value):
            currentIndex += value
        }
    }

    private func debug(instruction: BootInstruction?) {
        guard let instruction = instruction else { return }

        switch instruction {
        case .noop(value: _):
            print("[NOP]   \t@ \(currentIndex) # \(accumulator)")
        case .accumulate(value: let value):
            print("[ACC] \(value) \t@ \(currentIndex) # \(accumulator)")
        case .jump(value: let value):
            print("[JMP] \(value) \t@ \(currentIndex) # \(accumulator)")
        }
    }

    /// Run the boot code and detect the last instruction before we looped
    ///
    /// - Returns: Index that triggers the loop. (`-1` if none)
    @discardableResult
    func detectLoop() -> Int {
        var foundLoop: Bool = false

        run {
            // after each instruction check that the next instruction hasn't already been executed
            if self.runInstructionIndices.contains(self.currentIndex) {
                self.currentIndex = -1 // place the current index outside of bounds to stop the run loop
                foundLoop = true
            }
        }

        return foundLoop ? (runInstructionIndices.last ?? -1) : -1
    }

    /// Detect any loop and attempt to fix it by swapping last failing instruction
    func fixLoop() {
        let originalInstructions = instructions // grab a copy, just in case

        var hasInfiniteLoop = true
        var failedSwapIndices = [Int]()
        var originalInst: BootInstruction?
        var swapIndex: Int = -1

        // steps:
        // - (main loop) -> while we still have an infinite loop
        // - look through run instructions and find `nop` and `jmp`
        // - see if we've already attempted to "fix" this index (skip and continue if we have)
        // - swap instruction (saving off original & index)
        // - detect loop
        // - if no loop - success!
        // - if loop, swap back instruction, record attempted fix

        while hasInfiniteLoop {
            // find next swappable index based on previously run instructions
            if let indexToTry = findSwappableInstruction(ignoring: failedSwapIndices) {
                swapIndex = indexToTry
                originalInst = swapInstruction(index: indexToTry)
            } else {
                print("**** No swappable instruction found. First run?")
            }

            let idx = detectLoop() // see if we still have a loop (ie: index == -1)
            guard idx != -1 else { hasInfiniteLoop = false; continue } // we're done

            // revert the change... (if we have one)
            if instructions.indices.contains(swapIndex), let ogInst = originalInst {
                failedSwapIndices.append(swapIndex)
                instructions[swapIndex] = ogInst
                swapIndex = -1
                originalInst = nil
            }
        }
    }

    /// Scan through the run instructions and look for indicies we can attempt to swap.
    ///
    /// - Parameters:
    ///     - ignoring: Indices to ignore when looking for swappable
    private func findSwappableInstruction(ignoring indicesToIgnore: [Int]) -> Int? {
        runInstructionIndices.first { idx -> Bool in
            guard !indicesToIgnore.contains(idx) else { return false }
            return isInstructionSwappable(index: idx)
        }
    }

    /// Is the instruction at the given index swappable?
    ///
    /// - Note: "Swappable" is defined as a NOOP or JUMP instruction.
    private func isInstructionSwappable(index: Int) -> Bool {
        let inst = instructions[index]
        if case .noop(_) = inst {
            return true
        } else if case .jump(_) = inst {
            return true
        } else {
            return false
        }
    }

    /// Swap the instruction at the given index and return the original value.
    ///
    /// - Note: Instruction at index is checked for swappability first...
    private func swapInstruction(index: Int) -> BootInstruction? {
        guard isInstructionSwappable(index: index) else { return nil }
        let originalInstruction = instructions[index]

        if case .jump(let value) = originalInstruction {
            print("Swapping JMP for NOP")
            instructions[index] = .noop(value: value)
        } else if case .noop(let value) = originalInstruction {
            print("Swapping NOP for JMP")
            instructions[index] = .jump(value: value)
        } else {
            print("Not sure what this is...")
        }

        return originalInstruction
    }
}
