//
//  IntCodeInstruction.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/7/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct IntCodeInstruction {
    enum OpCode: Int {
        case add = 1
        case multiply = 2
        case input = 3
        case output = 4
        case jumpIfTrue = 5
        case jumpIfFalse = 6
        case lessThan = 7
        case equals = 8
        case adjustRelativeBase = 9
        case terminate = 99

        // the following are error cases
        case error = -1
        case unknownInstruction = -2
    }

    enum OpCodeParam {
        case position(offset: Int)
        case immediate(offset: Int)
        case relative(offset: Int)

        static func param(code: Int? = 0, offset: Int) -> OpCodeParam {
            switch code {
            case 1:
                return .immediate(offset: offset)
            case 2:
                return .relative(offset: offset)
            default:
                return .position(offset: offset)
            }
        }
    }

    let opcode: OpCode
    let parameters: [OpCodeParam]
    var rawInput: Int?

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

        rawInput = input
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
        case .input, .output, .adjustRelativeBase:
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
        case .terminate, .error, .unknownInstruction:
            break // no parameters
        }

        parameters = paramInfo
    }
}

extension IntCodeInstruction: CustomStringConvertible {
    var description: String {
        var typeString = ""
        switch opcode {
        case .add:
            typeString = "Add"
        case .multiply:
            typeString = "Multiply"
        case .input:
            typeString = "Input"
        case .output:
            typeString = "Output"
        case .jumpIfTrue:
            typeString = "JumpIfTrue"
        case .jumpIfFalse:
            typeString = "JumpIfFalse"
        case .lessThan:
            typeString = "LessThan"
        case .equals:
            typeString = "Equals"
        case .adjustRelativeBase:
            typeString = "AdjustRelativeBase"
        case .terminate:
            typeString = "Terminate"
        case .error:
            typeString = "Error"
        case .unknownInstruction:
            typeString = "UnknownInstruction"
        }

        var output = "Instruction.\(typeString)("
        if let raw = rawInput {
            output += "raw: \(raw), "
        }
        output += "parameters: [\(parameters.map { $0.description }.joined(separator: ", "))]"
        output += ")"
        return output
    }
}

extension IntCodeInstruction.OpCodeParam: CustomStringConvertible {
    var description: String {
        var typeString = ""
        var theOffset: Int

        switch self {
        case .immediate(offset: let offset):
            typeString = "Immediate"
            theOffset = offset
        case .position(offset: let offset):
            typeString = "Position"
            theOffset = offset
        case .relative(offset: let offset):
            typeString = "Relative"
            theOffset = offset
        }

        return "Param.\(typeString)(offset: \(theOffset))"
    }
}
