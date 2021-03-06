#!/usr/bin/env swift

import Foundation

struct Computer {
    var registers: [String: Int]
    var instructions: [ComputerInstruction]

    init() {
        registers = [ "a": 0, "b": 0, "c": 1, "d": 0 ]
        instructions = [ComputerInstruction]()
    }

    mutating func parse(instructions inputLines: [String]) {
        inputLines.forEach { input in
            if let instruction = CopyInstruction(input) {
                instructions.append(instruction)
            } else if let instruction = JumpInstruction(input) {
                instructions.append(instruction)
            } else if let instruction = IncrementInstruction(input) {
                instructions.append(instruction)
            } else {
                print("WAT: \(input)")
            }
        }
    }

    mutating func run() {
        var runIndex = 0
        var linesRun = 0

        while runIndex < instructions.count {
            if linesRun >= 10000 {
                linesRun = 0
                sleep(2)
            }

            print(registers)
            let instruction = instructions[runIndex]

            switch instruction {
            case let copy as CopyInstruction:
                // print("COPY: \(input)")

                var fromValue: Int
                if let value = copy.fromValue {
                    fromValue = value
                } else if let register = copy.fromRegister {
                    fromValue = registers[register]!
                } else {
                    print("UH OH"); exit(1)
                }

                registers[copy.toRegister] = fromValue
            case let jump as JumpInstruction:
                // print("JUMP: \(input)")

                var fromValue = 0
                if let value = jump.fromValue {
                    fromValue = value
                } else if let register = jump.fromRegister {
                    fromValue = registers[register]!
                } else {
                    print("UH OH"); exit(1)
                }

                if fromValue != 0 {
                    // print("Jumping from \(parsingIndex) to \(parsingIndex + instruction.jumpValue)")
                    runIndex = runIndex + jump.jumpValue
                    continue // skip the increment below
                } else {
                    // print("Not JUMPing")
                }
            case let increment as IncrementInstruction:
                // print("INCREMENT: \(input)")
                let currentValue = registers[increment.register]!
                var newValue = currentValue

                switch increment.direction {
                case .up:
                    newValue = newValue + 1
                case .down:
                    newValue = newValue - 1
                }

                // print("REGISTER[\(instruction.register)] - from: \(currentValue) to: \(newValue)")
                registers[increment.register] = newValue
            default:
                print("WAT")
            }

            runIndex = runIndex + 1
            // linesRun = linesRun + 1
        }
    }
}

protocol ComputerInstruction { /* empty */ }

struct CopyInstruction : ComputerInstruction {
    var fromRegister: String?
    var fromValue: Int?
    let toRegister: String

    init?(_ input: String) {
        // http://rubular.com/r/gxqlzm8IK8
        let copyRegex = "cpy ([a-d]|\\d+) ([a-d])"
        guard let matches = input.matches(regex: copyRegex) else { return nil }
        guard let match = matches.first else { return nil }

        // the from is either a register or value
        let fromPlace = match.captures[0]
        if let _ = fromPlace.matches(regex: "\\d+") {
            fromValue = Int.init(fromPlace)!
        } else {
            fromRegister = fromPlace
        }

        toRegister = match.captures[1]
    }
}

struct JumpInstruction : ComputerInstruction {
    var fromRegister: String?
    var fromValue: Int?
    let jumpValue: Int

    init?(_ input: String) {
        // http://rubular.com/r/PlKeyw3N0u
        let jumpRegex = "jnz ([a-d]|\\d+) (-?\\d+)"
        guard let matches = input.matches(regex: jumpRegex) else { return nil }
        guard let match = matches.first else { return nil }

        let jumpCheck = match.captures[0]
        if let _ = jumpCheck.matches(regex: "\\d+") {
            fromValue = Int.init(jumpCheck)!
        } else {
            fromRegister = jumpCheck
        }

        jumpValue = Int.init(match.captures[1])!
    }
}

struct IncrementInstruction : ComputerInstruction {
    enum IncrementDirection: String {
        case up = "inc"
        case down = "dec"
    }

    let direction: IncrementDirection
    let register: String

    init?(_ input: String) {
        // http://rubular.com/r/VfX8DqIoVd
        let incrementRegex = "(inc|dec) ([a-d])"
        guard let matches = input.matches(regex: incrementRegex) else { return nil }
        guard let match = matches.first else { return nil }

        guard let dir = IncrementDirection(rawValue: match.captures[0]) else { return nil }
        direction = dir

        register = match.captures[1]
    }
}

// ----------------------------------------------------------------------------
extension String {
    struct RegexMatch : CustomDebugStringConvertible {
        let match: String
        let captures: [String]
        let range: NSRange

        var debugDescription: String {
            return "RegexMatch( match: '\(match)', captures: [\(captures)], range: \(range) )"
        }

        init(string: String, regexMatch: NSTextCheckingResult) {
            var theCaptures: [String] = (0..<regexMatch.numberOfRanges).flatMap { index in
                let range = regexMatch.rangeAt(index)
                if let _ = range.toRange() {
                    return (string as NSString).substring(with: range)
                } else {
                    return nil
                }
            }

            match = theCaptures.removeFirst() // the 0 index is the whole string that matches
            captures = theCaptures
            range = regexMatch.range
        }
    }

    func matches(regex: String) -> [RegexMatch]? {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: .caseInsensitive)
            let wholeThing = NSMakeRange(0, characters.count)
            let regexMatches = regex.matches(in: self, options: .withoutAnchoringBounds, range: wholeThing)

            guard let _ = regexMatches.first else { return nil }

            return regexMatches.flatMap { m in
                return RegexMatch.init(string: self, regexMatch: m)
            }
        } catch {
            return nil
        }
    }
}

// ----------------------------------------------------------------------------
// returns the lines out of the input file
func readInputData() -> [String] {
    guard let currentDir = ProcessInfo.processInfo.environment["PWD"] else {
        print("No current directory.")
        return []
    }

    let inputPath = "\(currentDir)/input.txt"
    do {
        let data = try String(contentsOfFile: inputPath, encoding: .utf8)
        let lines = data.components(separatedBy: "\n")
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .filter { !$0.isEmpty }
        return lines
    } catch {
        return []
    }
}

// ----------------------------------------------------------------------------
// MARK: - "MAIN()"
let lines = readInputData()

var computer = Computer()

print(computer)
print("\n")
computer.parse(instructions: lines)
computer.run()

print("Final ----------")
print(computer.registers)


// Part 1: ["b": 196418,  "a": 318007,  "d": 0, "c": 0]
// Part 2: ["b": 5702887, "a": 9227661, "d": 0, "c": 0]
