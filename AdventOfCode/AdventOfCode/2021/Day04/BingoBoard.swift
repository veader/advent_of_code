//
//  BingoBoard.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/4/21.
//

import Foundation

class BingoBoard {
    let board: [[Int]]
    var marked: Set<Coordinate> = Set<Coordinate>()
    // var map = [Int: [Coordinate]]()
    var map = [Int: Coordinate]()

    init?(board: [[Int]]) {
        let counts = board.map { $0.count }
        // all rows must be the same size and same height
        guard
            counts.unique().count == 1,
            board.count == (board.first?.count ?? 0)
        else { return nil }

        self.board = board
        createMap()
    }

    /// Mark any appearances of this number on the board
    func mark(_ num: Int) {
        guard let coordinate = map[num] else { return }
        marked.insert(coordinate)
//        if let coordinates = map[num] {
//            coordinates.forEach { marked.insert($0) }
//        }
    }

    func num(at: Coordinate) -> Int {
        return 0
    }

    /// Sum of all unmarked numbers on the board
    func sum() -> Int {
        var value = 0
        board.enumerated().forEach { x, row in
            row.enumerated().forEach { y, num in
                guard !marked.contains(Coordinate(x: x, y: y)) else { return }
                value += num
            }
        }
        return value
    }

    func hasBingo() -> Bool {
        let size = board.first?.count ?? 0

        // check rows
        for y in (0..<size) {
            if marked.filter({ $0.y == y }).count == size {
                return true
            }
        }

        // check columns
        for x in (0..<size) {
            if marked.filter({ $0.x == x }).count == size {
                return true
            }
        }

        return false
    }

    private func createMap() {
        board.enumerated().forEach { rowIdx, row in
            row.enumerated().forEach { colIdx, num in
//                var coordinates = map[num] ?? [Coordinate]()
//                coordinates.append(Coordinate(x: rowIdx, y: colIdx))
//                map[num] = coordinates
                map[num] = Coordinate(x: rowIdx, y: colIdx)
            }
        }
    }

    static func parse(_ input: [String]) -> BingoBoard? {
        let numbers: [[Int]] = input.map { line in
            line.split(separator: " ")
                .map({ String($0.trimmingCharacters(in: .whitespaces)) })
                .compactMap(Int.init)
        }
        return BingoBoard(board: numbers)
    }
}

extension BingoBoard: CustomDebugStringConvertible {
    var debugDescription: String {
        var output = [String]()
        board.enumerated().forEach { x, row in
            var rowOutput = [String]()
            row.enumerated().forEach { y, num in
                let c = Coordinate(x: x, y: y)
                if marked.contains(c) {
                    rowOutput.append(String(num).padding(toLength: 2, withPad: " ", startingAt: 0))
                } else {
                    rowOutput.append(" ·")
                }
            }
            output.append(rowOutput.joined(separator: " "))
        }

        return output.joined(separator: "\n")
    }
}
