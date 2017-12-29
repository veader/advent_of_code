//
//  DayTwentyOne.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/25/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DayTwentyOne: AdventDay {

    struct Grid: CustomDebugStringConvertible {
        let rows: [[Int]]

        var size: Int {
            assert(rows.count == (rows.first?.count ?? 0))
            return rows.count
        }

        var debugDescription: String {
            return self.rows.map { (row: [Int]) -> String in
                return row.map { $0 == 1 ? "#" : "." }.joined()
            }.joined(separator: "\n")
        }

        var stringForm: String {
            return self.rows.map { (row: [Int]) -> String in
                return row.map { $0 == 1 ? "#" : "." }.joined()
                }.joined(separator: "/")
        }

        init(rows: [[Int]]) {
            self.rows = rows
        }

        init(_ input: String) {
            rows = input.split(separator: "/")
                .map { String($0).trimmed() }
                .map { line -> [Int] in
                    return line.map { (c: Character) -> Int in
                        switch c {
                        case ".":
                            return 0
                        case "#":
                            return 1
                        default:
                            return 2
                        }
                    }
            }
        }

        func pixels(on: Bool = true) -> Int {
            return rows.reduce(0, { (result, row) -> Int in
                return result + row.reduce(0, +)
            })
        }

        func subGrids() -> [[Grid]] {
            if size % 2 == 0 {
                return split(gridSize: 2)
            } else if size % 3 == 0 {
                return split(gridSize: 3)
            } else {
                print("❗️ \(size) is not divisible cleanly by 2 or 3")
                return [[Grid]]()
            }
        }

        // splits current grid into smaller grids of the given size.
        // returns these sub-grids by rows for easier reconstruction.
        func split(gridSize: Int) -> [[Grid]] {
            var theSubGrids = [[Grid]]()

            let numSubGrids = size / gridSize
            for yIdx in (0..<numSubGrids) {
                var rowSubGrids = [Grid]()
                for xIdx in (0..<numSubGrids) {
                    let rowStart = yIdx * gridSize
                    let rowRange = rowStart..<(rowStart + gridSize)
                    let xStart = xIdx * gridSize
                    let xRange = xStart..<(xStart + gridSize)

                    let subGridRows = rows[rowRange].map { Array($0[xRange]) }
                    rowSubGrids.append(Grid(rows: subGridRows))
                }
                theSubGrids.append(rowSubGrids)
            }

            return theSubGrids
        }

        func enumerations() -> [String] {
            var versions = [String]()

            versions.append(self.stringForm)
            versions.append(self.mirror().stringForm)

            for turns in (0..<4) {
                let rotated = self.rotate(turns: turns)
                versions.append(rotated.stringForm)
                versions.append(rotated.mirror().stringForm)
            }

            return versions
        }

        func mirror() -> Grid {
            let mirrorRows = self.rows.map { $0.reversed() as [Int] }
            return Grid(rows: mirrorRows)
        }

        /**
         Rotate a given grid clockwise
         .#.    #..
         ..# -> #.#
         ###    ##.
         */
        func rotate(turns: Int = 1) -> Grid {
            guard turns > 0, (turns % 4) > 0 else { return self }

            let width = rows.count

            let rotatedRows = (0..<width).map { (x: Int) -> [Int] in
                return stride(from: width - 1, to: -1, by: -1).map { (y: Int) -> Int in
                    return rows[y][x]
                }
            }

            let rotatedGrid = Grid(rows: rotatedRows)

            if (turns % 4) == 1 {
                return rotatedGrid
            } else {
                return rotatedGrid.rotate(turns: (turns % 4) - 1)
            }
        }
    }

    struct Art {
        var grid: Grid
        let rules: [String: String]

        init(_ input: String) {
            let lines = input.split(separator: "\n").map { String($0).trimmed() }
            let ruleTuples = lines.flatMap { (line: String) -> (String, String)? in
                guard let arrowIndex = line.index(of: "=") else { return nil }
                return (String(line[line.startIndex..<line.index(before: arrowIndex)]),
                        String(line[line.index(arrowIndex, offsetBy: 2)..<line.endIndex]))
            }

            rules = Dictionary(uniqueKeysWithValues: ruleTuples)

            // initial starting grid
            grid = Grid(".#./..#/###")
        }

        mutating func run(iterations: Int = 5) {
            for iteration in (0..<iterations) {
                print("Iteration \(iteration)")
                print(grid)

                processGrid()
            }

            print("-------------- Finished --------------")
            print(grid)
        }

        mutating func processGrid() {
            var finalGrid = [[Grid]]()
            // divide grid into parts
            for rowGrids in grid.subGrids() {
                var expandedRowGrids = [Grid]()

                // process each row
                for sub in rowGrids {
                    let enumerations = sub.enumerations()

                    // find matching pattern for one the enumerations for this sub grid
                    for gridPattern in enumerations {
                        guard let rule = rules[gridPattern] else { continue }
                        let newGrid = Grid(rule)
                        expandedRowGrids.append(newGrid)
                        break // stop checking rules
                    }
                }

                finalGrid.append(expandedRowGrids)
            }

            // reconstruct new grid
            var finalGridContents = [[Int]]()
            for rowGrids in finalGrid {
                guard let rowCount = rowGrids.first?.size else {
                    print("❗️ Problem finding number of rows...")
                    return
                }

                // create a new
                for rowIdx in 0..<rowCount {
                    let newRow: [Int] = Array(rowGrids.map { $0.rows[rowIdx] }.joined())
                    finalGridContents.append(newRow)
                }
            }

            grid = Grid(rows: finalGridContents)
        }
    }
    
    // MARK: -

    func defaultInput() -> String? {
        let path = "\(dataPath())/day21input.txt"
        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 21: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 21: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 21: (Part 1) Answer ", answer)

        // ...
    }

    // MARK: -

    func partOne(input: String) -> Int? {
        var art = Art(input)
        art.run(iterations: 18)
        return art.grid.pixels(on: true)
    }

    func partTwo(input: String) -> Int? {
        return nil
    }
}
