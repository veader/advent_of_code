//
//  TreeMap.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/8/22.
//

import Foundation

class TreeMap {
    class Tree: CustomDebugStringConvertible {
        let height: Int

        var left: Bool = false
        var right: Bool = false
        var up: Bool = false
        var down: Bool = false

        var leftCount: Int = 0
        var rightCount: Int = 0
        var upCount: Int = 0
        var downCount: Int = 0

        var canBeSeen: Bool {
            up || down || left || right
        }

        var scenicScore: Int {
            [upCount, downCount, leftCount, rightCount].reduce(1, *)
        }

        init(size: Int) {
            self.height = size
        }

        var debugDescription: String {
            "<Tree height:\(height) | \(visibleBits)>"
        }

        var visibleBits: String {
            "\(up ? "1" : "0")\(down ? "1" : "0")\(left ? "1" : "0")\(right ? "1" : "0")"
        }

        var scoreDetails: String {
            "\(upCount)|\(downCount)|\(leftCount)|\(rightCount)|"
        }
    }

    var map: [[Tree]]
    var width: Int = 0

    init?(_ input: String) {
        let rows = input.split(separator: "\n").map(String.init)

        self.map = rows.map { row -> [Tree] in
            row.compactMap({ Int(String($0)) }).map { treeSize -> Tree in
                Tree(size: treeSize)
            }
        }

        // enforce equal widths...
        let widths = map.map({ $0.count }).unique()
        guard widths.count == 1 else { return nil }
        self.width = widths.first!
    }

    func tree(at coordinate: Coordinate) -> Tree? {
        guard valid(coordinate: coordinate) else { return nil }
        return map[coordinate.x][coordinate.y]
    }

    func column(_ y: Int) -> [Tree] {
        map.map { $0[y] }
    }

    private func valid(coordinate: Coordinate) -> Bool {
        guard map.indices.contains(coordinate.x), let row = map.first, row.indices.contains(coordinate.y) else { return false }
        return true
    }

    func detectVisibility() {
        for (idx, row) in map.enumerated() {
            detectVisibility(row: row, index: idx)
        }

//        print("-------------------------------------")

        let columns = (0..<width).map { column($0) }
        for (idx, column) in columns.enumerated() {
            detectVisibility(column: column, index: idx)
        }
    }

    private func detectVisibility(row: [Tree], index: Int) {
//        print("ROW: @\(index) \(row)")
        // handle edge cases (dad joke)
        if index == 0 {
            row.forEach { $0.up = true; $0.upCount = 0 }
            return
        } else if index == map.count - 1 {
            row.forEach { $0.down = true; $0.downCount = 0 }
            return
        }

        for (idx, tree) in row.enumerated() {
            // are any trees to the left >= height?
            let leftTrees = row.prefix(upTo: idx)
//            print("\tTrees left of \(idx): \(leftTrees)")
            if let leftIdx = Array(leftTrees.reversed()).firstIndex(where: { $0.height >= tree.height }) {
                tree.left = false
                tree.leftCount = leftIdx + 1
            } else {
                tree.left = true
                tree.leftCount = leftTrees.count
            }

            if row.indices.contains(idx + 1) {
                // are any trees to the right >= height?
                let rightTrees = row.suffix(from: idx + 1)
//                print("\tTrees right of \(idx): \(rightTrees)")
                if let rightIdx = Array(rightTrees).firstIndex(where: { $0.height >= tree.height }) {
                    tree.right = false
                    tree.rightCount = rightIdx + 1
                } else {
                    tree.right = true
                    tree.rightCount = rightTrees.count
                }
            } else { // right edge
                tree.right = true
                tree.rightCount = 0
            }
        }
    }

    private func detectVisibility(column: [Tree], index: Int) {
//        print("COLUMN: @\(index) \(column)")
        // handle edge cases (dad joke)
        if index == 0 {
            column.forEach { $0.left = true; $0.leftCount = 0 }
            return
        } else if index == width - 1 {
            column.forEach { $0.right = true; $0.rightCount = 0 }
            return
        }

        for (idx, tree) in column.enumerated() {
            // are any trees to the up >= height?
            let upTrees = column.prefix(upTo: idx)
//            print("\tTrees up of \(idx): \(upTrees)")
            if let upIdx = Array(upTrees.reversed()).firstIndex(where: { $0.height >= tree.height }) {
                tree.up = false
                tree.upCount = upIdx + 1
            } else {
                tree.up = true
                tree.upCount = upTrees.count
            }

            if column.indices.contains(idx + 1) {
                // are any trees to the down >= height?
                let downTrees = column.suffix(from: idx + 1)
//                print("\tTrees down of \(idx): \(downTrees)")
                if let downIdx = Array(downTrees).firstIndex(where: { $0.height >= tree.height }) {
                    tree.down = false
                    tree.downCount = downIdx + 1
                } else {
                    tree.down = true
                    tree.downCount = downTrees.count
                }
            } else {
                tree.down = true
                tree.downCount = 0
            }
        }
    }

    func maxScenicScore() -> Int {
        map.flatMap { row in
            row.map { $0.scenicScore  }
        }.max() ?? 0
    }

    func visibleCount() -> Int {
        map.reduce(0) { sum, row in
            sum + row.reduce(0) { rowSum, tree in
                rowSum + (tree.canBeSeen ? 1 : 0)
            }
        }
    }

    func printVisibility() {
        let output: [String] = map.map { row in
            row.map({ $0.canBeSeen ? "*" : " " }).joined()
        }
        print(output.joined(separator: "\n"))
    }

    func printVisibilityBits() {
        let output: [String] = map.map { row in
            row.map({ $0.visibleBits }).joined(separator: " ")
        }
        print(output.joined(separator: "\n"))
    }

    func printScenicScores() {
        let max = maxScenicScore()

        let size = "\(max)".count // find the string width to use

        let output: [String] = map.map { row in
            row.map({ "\($0.scenicScore)".padded(with: " ", length: size) }).joined(separator: " ")
        }
        print(output.joined(separator: "\n"))
    }
}
