//
//  MathEquation.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/18/20.
//

import Foundation

struct MathEquation {
    enum MathOperation: String {
        case addition = "+"
        case multiplication = "*"

        func perform(lhs: Int, rhs: Int) -> Int {
            switch self {
            case .addition:
                return lhs + rhs
            case .multiplication:
                return lhs * rhs
            }
        }
    }

    /// Raw form of the equation
    let equationString: String

    /// Equation broken down by characters
    let equation: [String]

    init(_ input: String) {
        equationString = input
        equation = input.map(String.init).filter { $0 != " " }
    }

    func solve() -> Int {
        var equationCopy = equation
        return solve(equation: &equationCopy)
    }

    func solve(equation equationArray: inout [String]) -> Int {
        var total = 0
        var currentOperation: MathOperation?

        while !equationArray.isEmpty {
            let nextItem = equationArray.removeFirst()

            if nextItem == "(" {
                // recurse in one level...
                let internalValue = solve(equation: &equationArray)
                if let operation = currentOperation {
                    total = operation.perform(lhs: total, rhs: internalValue)
                    currentOperation = nil // clear the opeartion after we've used it
                } else {
                    total = internalValue
                }
            } else if nextItem == ")" {
                // we've hit the end of this level, return out...
                return total
            } else if let intValue = Int(nextItem) {
                if let operation = currentOperation {
                    total = operation.perform(lhs: total, rhs: intValue)
                    currentOperation = nil // clear the opeartion after we've used it
                } else {
                    total = intValue
                }
            } else if let operation = MathOperation(rawValue: nextItem) {
                currentOperation = operation
            }
        }

        return total
    }
}
