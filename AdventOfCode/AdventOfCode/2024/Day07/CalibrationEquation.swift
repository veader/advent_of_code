//
//  CalibrationEquation.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/7/24.
//

import Foundation

struct CalibrationEquation {
    let result: Int
    let values: [Int]

    enum Operation: String, CaseIterable {
        case add = "+"
        case multiply = "*"

        func apply(_ left: Int, _ right: Int) -> Int {
            switch self {
            case .add: return left + right
            case .multiply: return left * right
            }
        }
    }

    init?(_ input: String) {
        let pieces = input.split(separator: ":").map(String.init)
        guard pieces.count == 2,
              let first = pieces.first,
              let firstNum = Int(first),
              let last = pieces.last
                else { return nil }

        self.result = firstNum
        self.values = last.split(separator: " ").map(String.init).compactMap(Int.init)
    }

    func searchForValidOperations() -> [[Operation]] {
        guard let firstValue = values.first else { return [] }
        return Operation.allCases.compactMap {
            test(operation: $0, operations: [], sum: firstValue, idx: 1)
        }.flatMap { $0 } // flatten from [[[Operation]]] to [[Operation]]
    }

    /// Test applying the operator to the sum and value at the index.
    /// Proceed to search if idx is not the end of the array.
    ///
    /// - Returns: Collection of operators that equal our result or nil
    func test(operation: Operation, operations: [Operation], sum: Int, idx: Int) -> [[Operation]]? {
        guard idx < values.count else { return [] } // bounds checking

        let updatedSum = operation.apply(sum, values[idx])
        let updatedOperations = operations + [operation]

        if updatedSum > result { return nil }

        //print("Test: @\(idx) \(sum) \(operation.rawValue) \(values[idx]) = \(updatedSum) [Goal: \(result)] | [\(operations)]")

        if idx == values.count - 1 {
//            print("At the end...")
            // if we've reached the end, confirm we have a proper equation
            guard updatedSum == result else { return nil }
//            print("Success!")
            return [updatedOperations]
        }

        let nextIdx = values.index(after: idx)

        return Operation.allCases.compactMap {
            test(operation: $0, operations: updatedOperations, sum: updatedSum, idx: nextIdx)
        }.flatMap { $0 } // flatten from [[[Operation]]] to [[Operation]]
    }
}