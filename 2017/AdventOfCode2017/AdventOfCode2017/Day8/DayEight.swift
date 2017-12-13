//
//  DayEight.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/8/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DayEight: AdventDay {

    struct CPU {

        struct Instruction: CustomDebugStringConvertible {
            enum EqualityTest: String {
                case equal = "=="
                case notEqual = "!="
                case greater = ">"
                case less = "<"
                case greaterOrEqual = ">="
                case lessOrEqual = "<="
                case noop
            }

            let readRegister: String
            let writeRegister: String
            let changeAmount: Int
            let test: EqualityTest
            let testValue: Int

            init?(_ text: String) {
                // format: b inc 5 if a > 1
                // (write reg) (inc|dec) (change amt) if (read reg) (test) (test value)
                var pieces = text.split(separator: " ").map(String.init)
                guard pieces.count >= 7 else { return nil }

                writeRegister = pieces[0]
                readRegister = pieces[4]

                var multiplier = 1
                let direction = pieces[1]
                if direction == "dec" {
                    multiplier = -1
                }

                changeAmount = (Int(pieces[2]) ?? 0) * multiplier

                test = EqualityTest.init(rawValue: pieces[5]) ?? .noop
                testValue = Int(pieces[6]) ?? 0
            }

            var debugDescription: String {
                return "\(writeRegister) inc \(changeAmount) if \(readRegister) \(test.rawValue) \(testValue)"
            }
        }

        var registers = [String: Int]()
        let instructions: [Instruction]
        var maxValue: Int?

        init?(_ text: String) {
            let lines = text.split(separator: "\n").map(String.init).map { $0.trimmed() }
            instructions = lines.flatMap(Instruction.init)
        }

        mutating func execute() {
            for instruction in instructions {
                // print("-----------------------")
                // print(registers)
                // print(instruction)

                if test(instruction: instruction) {
                    // print("TEST PASS!")
                    write(register: instruction.writeRegister, change: instruction.changeAmount)
                }

                maxValue = max(maxValue ?? 0, maxRegisterValue() ?? 0)
            }
        }

        func maxRegisterValue() -> Int? {
            return registers.values.max()
        }

        private func test(instruction: Instruction) -> Bool {
            let value = read(register: instruction.readRegister)

            switch instruction.test {
            case .equal:
                return value == instruction.testValue
            case .notEqual:
                return value != instruction.testValue
            case .greater:
                return value > instruction.testValue
            case .less:
                return value < instruction.testValue
            case .greaterOrEqual:
                return value >= instruction.testValue
            case .lessOrEqual:
                return value <= instruction.testValue
            case .noop:
                return false
            }
        }

        private func read(register: String) -> Int {
            return registers[register] ?? 0
        }

        private mutating func write(register: String, change: Int) {
            registers[register] = read(register: register) + change
        }
    }

    // MARK: -

    func defaultInput() -> String? {
        let path = "\(dataPath())/day8input.txt"
        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 8: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 8: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 8: (Part 1) Answer ", answer)

        let thing2 = partTwo(input: runInput)
        guard let answer2 = thing2 else {
            print("Day 8: (Part 2) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 8: (Part 2) Answer ", answer2)
    }

    // MARK: -

    func partOne(input: String) -> Int? {
        guard var cpu = CPU(input) else { return nil }
        cpu.execute()
        print(cpu.registers)
        return cpu.maxRegisterValue()
    }

    func partTwo(input: String) -> Int? {
        guard var cpu = CPU(input) else { return nil }
        cpu.execute()
        print(cpu.registers)
        return cpu.maxValue
    }
}
