//
//  IntCodeMachine.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/2/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct IntCodeMachine {
    struct Instruction {
        enum OpCode: Int {
            case add = 1
            case multiply = 2
            case input = 3
            case output = 4
            case jumpIfTrue = 5
            case jumpIfFalse = 6
            case lessThan = 7
            case equals = 8
            case terminate = 99

            // the following are error cases
            case error = -1
            case unknownInstruction = -2
        }

        enum OpCodeParam {
            case position(offset: Int)
            case immediate(offset: Int)

            static func param(code: Int? = 0, offset: Int) -> OpCodeParam {
                switch code {
                case 1:
                    return .immediate(offset: offset)
                default:
                    return .position(offset: offset)
                }
            }
        }

        let opcode: OpCode
        let parameters: [OpCodeParam]

        /// Offset to jump to reach the next instruction
        var offset: Int {
            return parameters.count + 1
        }

        init(opcode: OpCode) {
            parameters = [OpCodeParam]()
            self.opcode = opcode
        }

        init(input: Int) {
            // 1002 - parsed from right to left
            //    - last 2 chars (02) are opcode
            //    - then 1 char (0) for 1st param should be in position mode
            //    - then 1 char (1) for 2nd param should be in immidate mode
            //    - then 3rd param should default to position mode

            var rawOpCode: Int

            var stringInput = String(input)
            if stringInput.count > 2 { // only need to do this if we have param input as well
                let codeString = String(stringInput.suffix(2))
                stringInput = String(stringInput.dropLast(2))

                if let code = Int(codeString) {
                    rawOpCode = code
                } else {
                    rawOpCode = -2 // unknown
                }
            } else {
                stringInput = "" // no param data found
                rawOpCode = input
            }

            opcode = OpCode(rawValue: rawOpCode) ?? OpCode.unknownInstruction

            var paramInfo = [OpCodeParam]()

            switch opcode {
            case .input, .output:
                // these instructions have 1 param
                paramInfo.append(OpCodeParam.param(code: Int(String(stringInput.popLast() ?? Character("a"))), offset: 1))
            case .jumpIfTrue, .jumpIfFalse:
                // these instructions have 2 params
                for offset in 1...2 {
                    paramInfo.append(OpCodeParam.param(code: Int(String(stringInput.popLast() ?? Character("a"))), offset: offset))
                }
            case .add, .multiply, .lessThan, .equals:
                // these instructions have 3 params
                for offset in 1...3 {
                    paramInfo.append(OpCodeParam.param(code: Int(String(stringInput.popLast() ?? Character("a"))), offset: offset))
                }
            default:
                break // no params
            }

            parameters = paramInfo
        }
    }

    private var internalMemory: [Int]
    var memory: [Int] {
        get { return internalMemory }
    }

    var instructionPointer: Int
    var inputs = [Int]()
    var outputs = [Int]()

    var debug: Bool = false

    mutating func run() {
        var stepResult = runStep()
        while stepResult.opcode != .terminate {
            stepResult = runStep()

            if stepResult.opcode == .error {
                print("Found an error running step... Exiting!")
                stepResult = Instruction(opcode: .terminate)
            } else if stepResult.opcode == .unknownInstruction {
                print("Unknown instruction found... Exiting!")
                stepResult = Instruction(opcode: .terminate)
            }
        }
    }

    mutating func runStep() -> Instruction {
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
            else { return instruction }

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
            guard let input = gatherInput() else { print("No input provided"); exit(1) }
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

        return instruction
    }

    func value(at index: Int, heap: [Int], params: [IntCodeMachine.Instruction.OpCodeParam]) -> Int {
        var value = heap[index]
        if case .position(offset: _) = params[index] {
            value = memory(at: value)
        }

        return value
    }

    mutating func gatherInput() -> Int? {
        guard !inputs.isEmpty else { return nil }
        // TODO: read input from user
        return inputs.removeFirst()
    }

    func currentInstruction() -> Instruction {
        guard
            memory.indices.contains(instructionPointer)
            else { return Instruction(opcode: .unknownInstruction) }

        return Instruction(input: memory[instructionPointer])
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

    init(instructions: String) {
        instructionPointer = 0
        internalMemory = IntCodeMachine.parse(instructions: instructions)
    }

    static func parse(instructions: String) -> [Int] {
        return instructions
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .split(separator: ",")
                .compactMap { Int($0) }
    }
}
