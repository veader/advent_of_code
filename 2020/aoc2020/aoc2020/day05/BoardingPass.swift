//
//  BoardingPass.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/5/20.
//

import Foundation

struct BoardingPass {
    let row: Int
    let column: Int

    let rowData: String
    let columnData: String

    var seatID: Int {
        (row * 8) + column
    }

    init?(_ input: String) {
        guard input.count == 10 else { return nil }
        rowData = String(input.dropLast(3))
        columnData = String(input.dropFirst(7))

        row = BoardingPass.calculate(rowData, totalItems: 128)
        column = BoardingPass.calculate(columnData, totalItems: 8)
    }

    /// Use binary space partitioning to find row/column given data.
    static func calculate(_ data: String, totalItems: Int = 128) -> Int {
        var range = 0..<totalItems

        for char in Array(data) {
            let size = range.count / 2

            switch char {
            case "F", "L":
                range = range.lowerBound..<(range.lowerBound + size)
            case "B", "R":
                range = (range.lowerBound + size)..<range.upperBound
            default:
                print("HUH? \(char)")
            }
        }

        return range.lowerBound
    }
}
