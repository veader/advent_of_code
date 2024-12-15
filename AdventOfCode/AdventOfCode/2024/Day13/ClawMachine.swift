//
//  ClawMachine.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/13/24.
//

import Foundation

struct ClawMachine {

    typealias ClawButton = (x: Int, y: Int)

    let buttonA: ClawButton
    let buttonB: ClawButton
    let prize: Coordinate

    private let buttonRegex = /Button\s(A|B):\sX\+(\d+),\sY\+(\d+)/
    private let prizeRegex = /Prize:\sX=(\d+),\sY=(\d+)/

    init?(input: [String]) throws {
        guard input.count == 3 else { return nil }

        var a: ClawButton?
        var b: ClawButton?
        var prize: Coordinate?

        for line in input {
            if let match = line.firstMatch(of: buttonRegex) {
                if match.1 == "A", let x = Int(match.2), let y = Int(match.3) {
                    a = (x, y)
                } else if match.1 == "B", let x = Int(match.2), let y = Int(match.3) {
                    b = (x, y)
                } else {
                    print("Unknown button: \(line)")
                }
            } else if let match = line.firstMatch(of: prizeRegex) {
                if let x = Int(match.1), let y = Int(match.2) {
                    prize = Coordinate(x: x, y: y)
                } else {
                    print("Unknown prize: \(line)")
                }
            } else {
                print("Not sure what to do with: \(line)")
            }
        }

        guard let a, let b, let prize else { return nil }

        self.buttonA = a
        self.buttonB = b
        self.prize = prize
    }
}

extension ClawMachine: CustomDebugStringConvertible {
    var debugDescription: String {
        "<ClawMachine: Prize:\(prize) | A:\(buttonA) | B:\(buttonB)>"
    }
}
