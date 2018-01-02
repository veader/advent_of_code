//
//  DayTwentyThree.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 1/1/18.
//  Copyright © 2018 v8logic. All rights reserved.
//

import Foundation

struct DayTwentyThree: AdventDay {

    struct CoProcessor {
        enum CoProcessorInstruction {
            // NOTE: value can either be a string (register) or int
            case set(register: String, value: String)
            case subtract(register: String, value: String)
            case multiply(register: String, value: String)
            case jump(value: String, offset: String)

            static func read(_ input: String) -> CoProcessorInstruction? {
                let parts = input.split(separator: " ").map { String($0).trimmed() }
                let verb = parts[0]

                switch verb {
                case "set":
                    guard parts.count >= 3 else { return nil }
                    return .set(register: parts[1], value: parts[2])
                case "sub":
                    guard parts.count >= 3 else { return nil }
                    return .subtract(register: parts[1], value: parts[2])
                case "mul":
                    guard parts.count >= 3 else { return nil }
                    return .multiply(register: parts[1], value: parts[2])
                case "jnz":
                    guard parts.count >= 3 else { return nil }
                    return .jump(value: parts[1], offset: parts[2])
                default:
                    print("Unknown verb: \(verb)")
                    return nil
                }
            }
        }

        let instructions: [CoProcessorInstruction]
        var currentIndex: Int = 0
        var registers: [String: Int] = [String: Int]()
        var soundsPlayed: [Int] = [Int]()
        var multiplyCount: Int = 0

        init(_ input: String) {
            instructions = input.split(separator: "\n")
                .map { String($0).trimmed() }
                .flatMap { CoProcessorInstruction.read($0) }
        }

        mutating func play(printing: Bool = false) {
            // perform instructions until we hit a "recover"

            var instruction: CoProcessorInstruction
            while currentIndexInBounds() {
                defer {
                    currentIndex += 1
                    if printing { print("--------") }
                }

                instruction = instructions[currentIndex]

                if printing { printState() }

                switch instruction {
                case .set(register: let reg, value: let value):
                    guard let intValue = registerOrValue(of: value) else {
                        print("[SET] Unable to determine value of \(value)")
                        break
                    }
                    if printing { print("SET \(reg) = \(value) -> \(intValue)") }
                    registers[reg] = intValue
                case .subtract(register: let reg, value: let value):
                    guard let intValue = registerOrValue(of: value) else {
                        print("[SUB] Unable to determine value of \(value)")
                        break
                    }
                    if printing { print("SUB \(reg) = \(value) -> \(intValue)") }
                    registers[reg] = (registers[reg] ?? 0) - intValue
                case .multiply(register: let reg, value: let value):
                    guard let intValue = registerOrValue(of: value) else {
                        print("[MUL] Unable to determine value of \(value)")
                        break
                    }
                    if printing { print("MUL \(reg) = \(value) -> \(intValue)") }
                    registers[reg] = (registers[reg] ?? 0) * intValue
                    multiplyCount += 1
                case .jump(value: let value, offset: let offsetValue):
                    guard
                        let intValue = registerOrValue(of: value),
                        let offset = registerOrValue(of: offsetValue)
                        else {
                            print("[JNZ] Unable to determine value of \(value) or \(offsetValue)")
                            break
                    }

                    if printing { print("JUMP \(value) -> \(intValue) : offset \(offsetValue) -> \(offset)") }

                    if intValue != 0 {
                        currentIndex += offset
                        currentIndex -= 1 // because defer will add one
                    }
                }
            }
        }

        private func currentIndexInBounds() -> Bool {
            return (0..<instructions.count).contains(currentIndex)
        }

        private func registerOrValue(of input: String) -> Int? {
            if let value = Int(input) {
                return value
            } else {
                return registers[input] ?? 0
            }
        }

        func printState() {
            print("Registers: \(registers)")
        }
    }


    // MARK: -

    func defaultInput() -> String? {
        let path = "\(dataPath())/day23input.txt"
        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 23: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 23: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 23: (Part 1) Answer ", answer)

        // ...
    }

    // MARK: -

    func partOne(input: String) -> Int? {
        var coproc = CoProcessor(input)
        coproc.play(printing: false)
        return coproc.multiplyCount
    }

    func partTwo(input: String) -> Int? {
        return nil
    }
}

