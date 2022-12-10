//
//  SimpleCPU.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/10/22.
//

import Foundation
import RegexBuilder

class SimpleCPU {
    enum CPUInstruction: Equatable {
        case noop
        case addx(Int)

        static func parse(_ input: String) -> CPUInstruction? {
            if input == "noop" {
                return .noop
            } else if let match = input.firstMatch(of: addXRegex), let amount = Int(match.1) {
                return .addx(amount)
            }

            return nil
        }

        static let addXRegex = Regex {
            "addx"
            One(.whitespace)
            Capture {
                Optionally("-")
                OneOrMore(.digit)
            }
        }
    }

    let instructions: [CPUInstruction]

    /// Cycles contains the value of X *after* the given cycle is complete
    var cycles: [Int] = [1] // initial cycle starts with X = 1

    init(_ input: String) {
        self.instructions = input.split(separator: "\n").map(String.init).compactMap { CPUInstruction.parse($0) }

        // TODO: capture amount of addX instructions and use it to determine size of cycles array
    }

    /// Run the instructions through the CPU and calculate value of `X` after each cycle is run
    func run() {
        var currentCycle = 1
        var currentX = 1 // starts with 1

        for instruction in instructions {
            switch instruction {
            case .noop:
                // no-op, record existing X value
                cycles.append(currentX)
                currentCycle += 1
            case .addx(let change):
                // addX takes 2 cycles to run, record existing X value at end of this skipped cycle
                cycles.append(currentX)
                currentCycle += 1

                // adjust value of X and record
                currentX += change
                cycles.append(currentX)
                currentCycle += 1
            }
        }
    }

    /// Draw the display. Display is 40 pixels wide and 6 pixels tall.
    func draw() {
        let displayWidth = 40
        let displayHeight = 6

        var start = 1
        var lines = [String]()

        while start < displayWidth * displayHeight {
            lines.append(outputRow(start: start, width: displayWidth))
            start += displayWidth
        }

        print(lines.joined(separator: "\n"))
    }

    func outputRow(start: Int, width: Int) -> String {
        var row = Array(repeating: ".", count: width)

        for (idx, cycle) in (start...(start + width)).enumerated() {
            let pixelCenter = value(during: cycle)
            let pixelLocations = [pixelCenter - 1, pixelCenter, pixelCenter + 1] // pixel is 3 wide

            if pixelLocations.contains(idx) {
                row[idx] = "#"
            }
        }

        return row.joined()
    }

    /// Get the value of the X register *during* the given cycle.
    /// - Note: `0` is returned in invalid cases.
    func value(during cycle: Int) -> Int {
        // TODO: we should maybe consider further out cycles which have no more instructions and X would be the same...

        guard cycles.startIndex < cycle, cycles.indices.contains(cycle - 1) else { return 0 }

        // since we want to know the value *during* a cycle, check the value of the last cycle
        let idx = cycles.index(before: cycle)
        return cycles[idx]
    }

    /// Get the value of the X register *after* the given cycle.
    /// - Note: `0` is returned in invalid cases.
    func value(after cycle: Int) -> Int {
        // TODO: we should maybe consider further out cycles which have no more instructions and X would be the same...
        guard cycles.indices.contains(cycle) else { return 0 }
        return cycles[cycle]
    }
}
