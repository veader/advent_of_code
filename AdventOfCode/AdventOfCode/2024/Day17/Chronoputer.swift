//
//  Chronoputer.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/19/24.
//

import Foundation

class Chronoputer {

    /// Instructions this Chronoputer understands
    enum ChronoInstruction: Int {
        case adv = 0
        case bxl = 1
        case bst = 2
        case jnz = 3
        case bxc = 4
        case out = 5
        case bdv = 6
        case cdv = 7
    }

    /// Potential errors for the Chronoputer
    enum ChronoError: Error {
        case operandIndexError
        case comboOperandError
        case jumpOOBError
    }

    /// Register A
    var registerA: Int
    /// Register B
    var registerB: Int
    /// Register C
    var registerC: Int

    /// Instructions to process with this computer
    var instructions: [Int]
    /// Current instruction pointer
    var instructionPtr: Int = 0

    /// Output gathered during execution
    var output: [Int] = []


    // MARK: - Init

    init(input: String) {
        var a = 0
        var b = 0
        var c = 0
        var insts: [Int] = []

        for line in input.lines() {
            if let match = line.firstMatch(of: /^Register (A|B|C):\s(\d+)/) {
                guard let value = Int(match.2) else { continue }
                switch match.1 {
                case "A":
                    a = value
                case "B":
                    b = value
                case "C":
                    c = value
                default:
                    continue
                }
            } else if let match = line.firstMatch(of: /^Program:\s(.+)/) {
                insts = match.1.split(separator: ",").map(String.init).compactMap(Int.init)
            }
        }

        registerA = a
        registerB = b
        registerC = c
        instructions = insts
    }

    // MARK: - Execute
    func execute() {
        do {
            while instructionPtr < instructions.count {
                let instructionNum = instructions[instructionPtr]
                guard let instruction = ChronoInstruction(rawValue: instructionNum) else {
                    print("Unable to read instruction at \(instructionPtr) = \(instructionNum)")
                    instructionPtr += 2 // move on?
                    continue
                }

                switch instruction {
                case .adv:
                    try adv()
                case .bxl:
                    try bxl()
                case .bst:
                    try bst()
                case .jnz:
                    let didJump = try jnz()
                    guard !didJump else { continue } // if we did jump, do not move the pointer
                case .bxc:
                    try bxc()
                case .out:
                    try out()
                case .bdv:
                    try bdv()
                case .cdv:
                    try cdv()
                }

                instructionPtr += 2 // move past this instruction and it's operand
            }
        } catch {
            print("Error: \(error)")
        }
    }


    // MARK: - Operands

    /// Determine the value of an operand if it is a "combo" value
    func comboValue(of operand: Int) -> Int? {
        switch operand {
        case 0...3:
            return operand
        case 4:
            return registerA
        case 5:
            return registerB
        case 6:
            return registerC
        case 7:
            print("Found a 7 operand!!")
            return nil
        default:
            return nil
        }
    }

    /// Read the operand from the index following the current instruction pointer.
    ///
    /// Process both literal and combo operands
    func readOperand(combo: Bool = false) throws -> Int {
        let idx = instructionPtr + 1
        guard instructions.indices.contains(idx) else { throw ChronoError.operandIndexError }

        let operand = instructions[idx]
        if combo {
            guard let value = comboValue(of: operand) else { throw ChronoError.comboOperandError }
            return value
        } else {
            return operand
        }
    }

    /// Reset the registers and output to empty state. Used in testing...
    func reset() {
        registerA = 0
        registerB = 0
        registerC = 0
        output = []
        instructionPtr = 0
    }


    // MARK: - Instructions

    /// Bitwise XOR: B = B ^ literal
    func bxl() throws {
        let operand = try readOperand()
        let result = registerB ^ operand
        registerB = result
    }

    /// Modulo: B = combo % 8
    func bst() throws {
        let operand = try readOperand(combo: true)
        let result = operand % 8
        registerB = result
    }

    /// Jump: returns if the instruction pointer was moved
    func jnz() throws -> Bool {
        // if register A == 0, do not jump
        guard registerA != 0 else { return false }

        let operand = try readOperand()
        guard instructions.indices.contains(operand) else { throw ChronoError.jumpOOBError }
        instructionPtr = operand

        return true
    }

    /// Bitwise XOR: B = B ^ C
    func bxc() throws {
        let result = registerB ^ registerC
        registerB = result
    }

    /// Output: out = combo % 8
    func out() throws {
        let operand = try readOperand(combo: true)
        let result = operand % 8
        output.append(result)
        // print(result)
    }

    /// Division: A = A / 2^(combo)
    func adv() throws {
        registerA = try divisionInstruction()
    }

    /// Division: B = A / 2^(combo)
    func bdv() throws {
        registerB = try divisionInstruction()
    }

    /// Division: C = A / 2^(combo)
    func cdv() throws {
        registerC = try divisionInstruction()
    }

    /// Division instruction: Used in adv, bdv, cdv
    private func divisionInstruction() throws -> Int {
        let operand = try readOperand(combo: true)
        let result = Decimal(registerA) / pow(2.0, operand)
        return (result as NSDecimalNumber).intValue

        // SO post if things get really large (likely in part 2?)
        /*
         var veryLargeDecimal = Decimal(floatLiteral: 100.123456789123)
         var rounded = Decimal()
         NSDecimalRound(&rounded, &veryLargeDecimal, 0, .down)
         let intValue = (rounded as NSDecimalNumber).intValue // This is now 100
         */
    }
}
