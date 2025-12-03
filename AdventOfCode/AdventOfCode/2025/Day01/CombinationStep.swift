//
//  CombinationStep.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/2/25.
//

import Foundation
import RegexBuilder

enum CombinationStep {
    case left(Int)
    case right(Int)

    func result(from input: Int) -> Int {
        switch self {
        case .left(let amount):
            return input - amount
        case .right(let amount):
            return input + amount
        }
    }

    static private let regex = /^([LR])(\d+)/

    static func parse(_ input: String) -> CombinationStep? {
        guard
            let match = input.firstMatch(of: Self.regex),
            let amount = Int(match.output.2)
        else { return nil }

        switch match.output.1 {
        case "L":
            return .left(amount)
        case "R":
            return .right(amount)
        default:
            return nil
        }
    }
}

extension CombinationStep: Equatable {}
extension CombinationStep: CustomStringConvertible {
    var description: String {
        switch self {
        case .left(let amount):
            return "L\(amount)"
        case .right(let amount):
            return "R\(amount)"
        }
    }
}
