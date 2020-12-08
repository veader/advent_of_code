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
    let instructions: [BootInstruction]

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

        switch instruction {
        case .noop(value: _):
            print("[NOP]   \t@ \(currentIndex) # \(accumulator)")
            currentIndex += 1 // do nothing and proceed to next instruction
        case .accumulate(value: let value):
            print("[ACC] \(value) \t@ \(currentIndex) # \(accumulator)")
            accumulator += value // adjust the accumulator value
            currentIndex += 1 // proceed to next instruction
        case .jump(value: let value):
            print("[JMP] \(value) \t@ \(currentIndex) # \(accumulator)")
            currentIndex += value
        }
    }

    /// Run the boot code and detect the last instruction before we looped
    func detectLoop() {
        run {
            // after each instruction check that the next instruction hasn't already been executed
            if self.runInstructionIndices.contains(self.currentIndex) {
                self.currentIndex = -1 // place the current index outside of bounds to stop the run loop
            }
        }
    }
}
