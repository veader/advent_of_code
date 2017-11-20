#!/usr/bin/env swift

import Foundation

struct Computer {
    var registers: [String: Int]
    var instructions: [ComputerInstruction]

    init() {
        registers = [ "a": 0, "b": 0, "c": 0, "d": 0 ]
        instructions = [ComputerInstruction]()
    }

    func printInstructions() {
        for instruction in instructions {
            print(instruction)
        }
    }

    mutating func parse(instructions inputLines: [String]) {
        inputLines.forEach { input in
            if let instruction = CopyInstruction(input) {
                instructions.append(instruction)
            } else if let instruction = JumpInstruction(input) {
                instructions.append(instruction)
            } else if let instruction = IncrementInstruction(input) {
                instructions.append(instruction)
            } else if let instruction = ToggleInstruction(input) {
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
            if linesRun >= 100000 {
                linesRun = 0
                sleep(1)
            }

            print(registers)
            let instruction = instructions[runIndex]

            switch instruction {
            case let copy as CopyInstruction:
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
                var fromValue = 0
                if let value = jump.fromValue {
                    fromValue = value
                } else if let register = jump.fromRegister {
                    fromValue = registers[register]!
                } else {
                    print("UH OH"); exit(1)
                }

                if fromValue != 0 {
                    var jumpValue = 0
                    if let value = jump.jumpValue {
                        jumpValue = value
                    } else if let register = jump.jumpRegister {
                        jumpValue = registers[register]!
                    } else {
                        print("UH OH2"); exit(1)
                    }
                    runIndex = runIndex + jumpValue
                    continue // skip the increment below
                }
            case let increment as IncrementInstruction:
                let currentValue = registers[increment.register]!
                var newValue = currentValue

                switch increment.direction {
                case .up:
                    newValue = newValue + 1
                case .down:
                    newValue = newValue - 1
                }

                registers[increment.register] = newValue
            case let toggle as ToggleInstruction:
                print("TOGGLE:")
                let registerValue = registers[toggle.register]!
                let instructionIndex = runIndex + registerValue
                if instructionIndex < instructions.count {
                    let instruction = instructions[instructionIndex]
                    print("Instruction before toggle: \(instruction)")
                    let toggledInstruction = toggle.toggle(instruction)
                    print("Instruction after toggle: \(toggledInstruction)")
                    instructions[instructionIndex] = toggledInstruction
                }
            default:
                print("WAT")
            }

            runIndex = runIndex + 1
            linesRun = linesRun + 1
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
        let copyRegex = "cpy ([a-d]|-?\\d+) ([a-d])"
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
    var jumpRegister: String?
    var jumpValue: Int?

    init?(_ input: String) {
        // http://rubular.com/r/PlKeyw3N0u
        let jumpRegex = "jnz ([a-d]|\\d+) ([a-d]|-?\\d+)"
        guard let matches = input.matches(regex: jumpRegex) else { return nil }
        guard let match = matches.first else { return nil }

        let jumpCheck = match.captures[0]
        if let _ = jumpCheck.matches(regex: "\\d+") {
            fromValue = Int.init(jumpCheck)!
        } else {
            fromRegister = jumpCheck
        }

        let theJumpValue = match.captures[1]
        if let jumpVal = Int.init(theJumpValue) {
            jumpValue = jumpVal
        } else {
            jumpRegister = theJumpValue
        }
        // jumpValue = Int.init(match.captures[1])!
    }
}

struct IncrementInstruction : ComputerInstruction {
    enum IncrementDirection: String {
        case up = "inc"
        case down = "dec"
    }

    let direction: IncrementDirection
    let register: String

    init(direction dir: IncrementDirection, register reg: String) {
        direction = dir
        register = reg
    }

    init?(_ input: String) {
        // http://rubular.com/r/VfX8DqIoVd
        let incrementRegex = "(inc|dec) ([a-d])"
        guard let matches = input.matches(regex: incrementRegex) else { return nil }
        guard let match = matches.first else { return nil }

        guard let dir = IncrementDirection(rawValue: match.captures[0]) else { return nil }
        direction = dir

        register = match.captures[1]
    }

    func reversed() -> IncrementInstruction {
        var reversedDirection: IncrementDirection
        switch direction {
        case .up:
            reversedDirection = .down
        case .down:
            reversedDirection = .up
        }
        return IncrementInstruction.init(direction: reversedDirection, register: self.register)
    }
}

struct NoOpInstruction : ComputerInstruction {
    let input: String
}

struct ToggleInstruction : ComputerInstruction {
    let register: String

    init?(_ input: String) {
        let toggleRegex = "tgl ([a-d])"
        guard let matches = input.matches(regex: toggleRegex) else { return nil }
        guard let match = matches.first else { return nil }

        register = match.captures[0]
    }

    func toggle(_ instruction: ComputerInstruction) -> ComputerInstruction {
        switch instruction {
        case let copy as CopyInstruction:
            print("COPY -> JUMP")
            let input = "jnz \(copy.fromRegister ?? "\(copy.fromValue!)") \(copy.toRegister)"
            guard let jump = JumpInstruction(input) else { return NoOpInstruction(input: input) }
            return jump
        case let jump as JumpInstruction:
            print("JUMP -> COPY")
            let input = "cpy \(jump.fromRegister ?? "\(jump.fromValue!)") \(jump.jumpValue)"
            guard let copy = CopyInstruction(input) else { return NoOpInstruction(input: input) }
            return copy
        case let increment as IncrementInstruction:
            print("INCREMENT -> (reversed) INCREMENT")
            return increment.reversed()
        case let toggle as ToggleInstruction:
            print("TOGGLE -> INCREMENT")
            let input = "inc \(toggle.register)"
            guard let inc = IncrementInstruction(input) else { return NoOpInstruction(input: input) }
            return inc
        default:
            print("WAT")
            return NoOpInstruction(input: "")
        }
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
// let lines = [
//     "cpy 2 a",
//     "tgl a",
//     "tgl a",
//     "tgl a",
//     "cpy 1 a",
//     "dec a",
//     "dec a",
// ]

var computer = Computer()

print(computer)
computer.registers["a"] = 7
print("\n")
computer.parse(instructions: lines)
computer.run()

print("Final ----------")
print(computer.registers)


// Part 1: ["b": 196418,  "a": 318007,  "d": 0, "c": 0]
// Part 2: ["b": 5702887, "a": 9227661, "d": 0, "c": 0]
