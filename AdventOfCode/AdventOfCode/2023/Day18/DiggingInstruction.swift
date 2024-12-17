//
//  DiggingInstruction.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/26/23.
//

import Foundation

struct DiggingInstruction {
    enum Direction: String {
        case up = "U"
        case down = "D"
        case left = "L"
        case right = "R"

        var direction: RelativeDirection {
            switch self {
            case .up:
                .north
            case .down:
                .south
            case .left:
                .west
            case .right:
                .east
            }
        }
    }

    let direction: Direction
    let distance: Int
    let color: String

    init?(_ input: String) {
        // Example: R 4 (#9505a2)
        guard
            let match = input.firstMatch(of: /^([UDLR]) (\d+) \((\#.{6})\)/),
            let tmpDirection = Direction(rawValue: String(match.output.1)),
            let tmpDistance = Int(String(match.output.2))
        else { return nil }

        direction = tmpDirection
        distance = tmpDistance
        color = String(match.output.3)
    }
}
