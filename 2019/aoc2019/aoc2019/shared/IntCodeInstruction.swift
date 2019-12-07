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
        case terminate = 99

        // the following are error cases
        case error = -1
        case unknownInstruction = -2
        case awaitingInput = -3
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
