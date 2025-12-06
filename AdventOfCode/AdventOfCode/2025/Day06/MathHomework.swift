//
//  MathHomework.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/6/25.
//

import Foundation

struct MathHomework {

    enum HomeworkOp: String {
        case add = "+"
        case multiply = "*"
    }

    struct HomeworkProblem {
        let values: [Int]
        let operation: HomeworkOp

        func solve() -> Int {
            switch operation {
            case .add:
                values.reduce(0, +)
            case .multiply:
                values.reduce(1, *)
            }
        }
    }

    let problems: [HomeworkProblem]
    let numbers: [[Int]]
    let operations: [HomeworkOp]

    static func parse(_ input: String?) -> MathHomework? {
        guard let input else { return nil }

        var nums = [[Int]]()
        var ops = [HomeworkOp]()

        // process each line of the input
        for line in input.lines() {
            let columns = line.split(separator: /\s/).map(String.init)
            let values = columns.compactMap(Int.init)

            if !values.isEmpty {
                nums.append(values)
            } else {
                ops = columns.compactMap { HomeworkOp(rawValue: $0) }
            }
        }

        // sanity checking...
        guard nums.count > 1, // we have (at min) to have 2 values to use with the operations
              let firstNum = nums.first,
              firstNum.count > 0, // make sure we have at least 1 problem
              ops.count == firstNum.count // make sure we have the same number of problem values and ops
        else {
            print("Something broke in parsing...")
            return nil
        }

        // make sure each number row is the same length
        let widths = nums.map({ $0.count })
        guard widths.unique().count == 1 else {
            print("Column width problem...")
            return nil
        }

        // turn values and ops into problems
        let width = widths.first! // we've checked they are all the same at this point...
        let problems: [HomeworkProblem] = (0..<width).map { idx in
            let values = nums.map { $0[idx] }
            let op = ops[idx]
            return HomeworkProblem(values: values, operation: op)
        }

        return MathHomework(problems: problems, numbers: nums, operations: ops)
    }

    static func parseDifferently(_ input: String?) -> MathHomework? {
        guard let input else { return nil }

        // turn the input into a 2D array of strings
        let data: [[String]] = input.lines().map({ $0.charSplit().reversed() })

        var values: [Int] = []
        var op: HomeworkOp = .add
        var problems: [HomeworkProblem] = []

        // fold these into numbers (and operators)
        let height = data.first?.count ?? 0
        for idx in (0..<height) {
            let col = data.map { $0[idx] }
            let nums = col.filter { ![" ", "+", "*"].contains($0) }

            if nums.isEmpty {
                // this must be a divider between problems, create one.
                problems.append(HomeworkProblem(values: values, operation: op))

                // reset
                values = []
                op = .add
            } else {
                // create value
                let value = Int(nums.joined()) ?? 0
                values.append(value)

                // check for operator
                if col.contains("+") {
                    op = .add
                } else if col.contains("*") {
                    op = .multiply
                }
            }
        }

        // add the last one
        problems.append(HomeworkProblem(values: values, operation: op))

        return MathHomework(problems: problems, numbers: [], operations: [])
    }

    func grandTotal() -> Int {
        problems.map({ $0.solve() }).reduce(0, +)
    }
}
