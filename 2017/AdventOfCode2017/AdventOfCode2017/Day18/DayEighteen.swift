//
//  DayEighteen.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/20/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DayEighteen: AdventDay {

    struct Duet {
        enum DuetInstruction {
            // NOTE: value can either be a string (register) or int
            case play(value: String)
            case set(register: String, value: String)
            case add(register: String, value: String)
            case multiply(register: String, value: String)
            case modulo(register: String, value: String)
            case recover(value: String)
            case jump(value: String, offset: String)

            static func read(_ input: String) -> DuetInstruction? {
                let parts = input.split(separator: " ").map { String($0).trimmed() }
                let verb = parts[0]

                switch verb {
                case "snd":
                    guard parts.count >= 2 else { return nil }
                    return .play(value: parts[1])
                case "set":
                    guard parts.count >= 3 else { return nil }
                    return .set(register: parts[1], value: parts[2])
                case "add":
                    guard parts.count >= 3 else { return nil }
                    return .add(register: parts[1], value: parts[2])
                case "mul":
                    guard parts.count >= 3 else { return nil }
                    return .multiply(register: parts[1], value: parts[2])
                case "mod":
                    guard parts.count >= 3 else { return nil }
                    return .modulo(register: parts[1], value: parts[2])
                case "rcv":
                    guard parts.count >= 2 else { return nil }
                    return .recover(value: parts[1])
                case "jgz":
                    guard parts.count >= 3 else { return nil }
                    return .jump(value: parts[1], offset: parts[2])
                default:
                    print("Unknown verb: \(verb)")
                    return nil
                }
            }
        }

        let instructions: [DuetInstruction]
        var currentIndex: Int = 0
        var registers: [String: Int] = [String: Int]()
        var soundsPlayed: [Int] = [Int]()

        init(_ input: String) {
            instructions = input.split(separator: "\n")
                                .map { String($0).trimmed() }
                                .flatMap { DuetInstruction.read($0) }
        }

        mutating func play(printing: Bool = false) -> Int? {
            // perform instructions until we hit a "recover"

            var instruction: DuetInstruction
            while currentInstructionIsNotRecover() && currentIndexInBounds() {
                defer { currentIndex += 1; if printing { print("--------") } }

                instruction = instructions[currentIndex]

                if printing { printState() }

                switch instruction {
                case .recover(value: let value):
                    let intValue = registerOrValue(of: value)
                    if printing { print("RCV \(value) -> \(intValue ?? 0)") }
                case .play(value: let value):
                    guard let freq = registerOrValue(of: value) else {
                        print("[SND] Unable to determine value of \(value)")
                        break
                    }
                    if printing { print("PLAY \(value) -> \(freq)") }
                    soundsPlayed.append(freq)
                case .set(register: let reg, value: let value):
                    guard let intValue = registerOrValue(of: value) else {
                        print("[SET] Unable to determine value of \(value)")
                        break
                    }
                    if printing { print("SET \(reg) = \(value) -> \(intValue)") }
                    registers[reg] = intValue
                case .add(register: let reg, value: let value):
                    guard let intValue = registerOrValue(of: value) else {
                        print("[ADD] Unable to determine value of \(value)")
                        break
                    }
                    if printing { print("ADD \(reg) = \(value) -> \(intValue)") }
                    registers[reg] = (registers[reg] ?? 0) + intValue
                case .multiply(register: let reg, value: let value):
                    guard let intValue = registerOrValue(of: value) else {
                        print("[MUL] Unable to determine value of \(value)")
                        break
                    }
                    if printing { print("MUL \(reg) = \(value) -> \(intValue)") }
                    registers[reg] = (registers[reg] ?? 0) * intValue
                case .modulo(register: let reg, value: let value):
                    guard let intValue = registerOrValue(of: value) else {
                        print("[MOD] Unable to determine value of \(value)")
                        break
                    }
                    if printing { print("MOD \(reg) = \(value) -> \(intValue)") }
                    registers[reg] = (registers[reg] ?? 0) % intValue
                case .jump(value: let value, offset: let offsetValue):
                    guard
                        let intValue = registerOrValue(of: value),
                        let offset = registerOrValue(of: offsetValue)
                        else {
                            print("[JGZ] Unable to determine value of \(value) or \(offsetValue)")
                            break
                        }

                    if printing { print("JUMP \(value) -> \(intValue) : offset \(offsetValue) -> \(offset)") }

                    if intValue > 0 {
                        currentIndex += offset
                        currentIndex -= 1 // because defer will add one
                    }
                }
            }

            // should be at a recover statement (or out of bounds index)
            if currentInstructionIsRecover() {
                return soundsPlayed.last
            }

            return nil
        }

        private func currentIndexInBounds() -> Bool {
            return (0..<instructions.count).contains(currentIndex)
        }

        private func currentInstructionIsRecover() -> Bool {
            guard case .recover(value: let value) = instructions[currentIndex] else { return false }
            let intValue = registerOrValue(of: value)
            return (intValue ?? 0) != 0
        }

        private func currentInstructionIsNotRecover() -> Bool {
            return !currentInstructionIsRecover()
        }

        private func registerOrValue(of input: String) -> Int? {
            if let value = Int(input) {
                return value
            } else {
                return registers[input]
            }
        }

        func printState() {
            print("Registers: \(registers)")
            print("Sounds Played: \(soundsPlayed)")
        }
    }

    // MARK: -

    func defaultInput() -> String? {
        let path = "\(dataPath())/day18input.txt"
        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 18: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 18: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 18: (Part 1) Answer ", answer)

        // ...
    }

    // MARK: -

    func partOne(input: String) -> Int? {
        var duet = Duet(input)
        return duet.play()
    }

    func partTwo(input: String) -> Int? {
        return nil
    }
}
