//
//  SupplyCrateMap.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/5/22.
//

import Foundation
import RegexBuilder

typealias SupplyCrateStack = [[SupplyCrateMap.SupplyBox]]

struct SupplyCrateMap {
    enum SupplyBox: Equatable {
        case empty
        case box(_: String)
    }

    struct Instruction {
        let moveAmount: Int
        let originIndex: Int
        let destinationIndex: Int

        var originIdx: Int {
            originIndex - 1
        }

        var destinationIdx: Int {
            destinationIndex - 1
        }
    }


    /// Stacks of boxes (`SupplyBox`). Each item in the outer collection is a row.
    ///     Indexing: (0,0) - The origin is top row, all the way to left. Largest row index is closest to the ground.
    ///     X is row, Y is column
    var stack: SupplyCrateStack
    var instructions: [Instruction]

    var height: Int {
        stack.count
    }

    var width: Int {
        stack.first?.count ?? 0
    }

    init(stack: SupplyCrateStack, instructions: [Instruction]) {
        self.stack = stack

        self.instructions = instructions
    }


    // MARK: - Methods

    mutating func followAllInstructions(grouped: Bool = false) {
        for instruction in instructions {
            if grouped {
                followUsingGroup(instruction: instruction)
            } else {
                follow(instruction: instruction)
            }
        }
    }

    /// Follow the given instruction and move the necessary pieces (one at a time)
    mutating func follow(instruction: Instruction) {
        // confirm our instruction is valid
        guard   let firstRow = stack.first,
                firstRow.count > instruction.originIdx,
                firstRow.count > instruction.destinationIdx
        else { return }

        (0..<instruction.moveAmount).forEach { _ in
            let topOrigin = topIndex(column: instruction.originIdx)
            let topDest = topIndex(column: instruction.destinationIdx)

            let adjustedRow = topDest - 1 // subtract to move "up

            var offset = 0 // adjustment for adding rows, if necessary
            if adjustedRow < 0 {
                stack = [emptyRow()] + stack // prepend a row to the top
                offset += 1
            }

            let originCoord = Coordinate(x: topOrigin + offset, y: instruction.originIdx)
            let destCoord = Coordinate(x: adjustedRow + offset, y: instruction.destinationIdx)
            guard let box = value(at: originCoord) else { print("No Box!"); return }
            assign(destCoord, box: box)
            clear(originCoord)
        }
    }

    /// Follow the given instruction and move the necessary pieces (as a group)
    mutating func followUsingGroup(instruction: Instruction) {
        // confirm our instruction is valid
        guard   let firstRow = stack.first,
                firstRow.count > instruction.originIdx,
                firstRow.count > instruction.destinationIdx
        else { return }

        var topDest = topIndex(column: instruction.destinationIdx)

        if topDest - instruction.moveAmount < 0 {
            let addedRowCount = instruction.moveAmount - topDest
            stack = Array(repeating: emptyRow(), count: addedRowCount) + stack // prepend some rows to the top
            topDest = topIndex(column: instruction.destinationIdx) // refetch the updated top destination coord
        }

        let coordsToMove = getTop(instruction.moveAmount, in: instruction.originIdx).reversed()
        for (idx, originCoord) in coordsToMove.enumerated() {
            let destCoord = Coordinate(x: topDest - (idx + 1), y: instruction.destinationIdx)

            guard let box = value(at: originCoord) else { print("NO BOX!"); return }
            assign(destCoord, box: box)
            clear(originCoord)
        }
    }

    /// What is the value at the given within the stacks?
    func value(at coord: Coordinate) -> SupplyBox? {
        guard valid(coordinate: coord) else { return nil }
        return stack[coord.x][coord.y]
    }

    /// Get a single stack's occupied coordinates within the overall set of stacks
    func column(_ y: Int) -> [Coordinate] {
        guard width > y else { return [] }

        return (0..<height).map { Coordinate(x: $0, y: y) }
    }

    /// Find the index of the top of this column. Returns 0 if stack not found
    func topIndex(column y: Int) -> Int {
        column(y).enumerated().first(where: { value(at: $0.element) != .empty })?.offset ?? height
    }

    /// Get the top (x) Coordinates from the given column
    func getTop(_ count: Int, in column: Int) -> [Coordinate] {
        let topIdx = topIndex(column: column)
        return (topIdx..<topIdx + count).map { Coordinate(x: $0, y: column) }.filter { valid(coordinate: $0) }
        //return coordinates.compactMap { value(at: $0) }.filter { $0 != .empty }
    }

    /// Get a new empty row that is the proper width
    func emptyRow() -> [SupplyBox] {
        guard let width = stack.first?.count else { return [] }
        return Array(repeating: .empty, count: width)
    }

    /// Is the given coordinate valid?
    func valid(coordinate: Coordinate) -> Bool {
        guard stack.indices.contains(coordinate.x), stack[coordinate.x].indices.contains(coordinate.y) else { return false }
        return true
    }

    /// Find the top boxes for each stack
    func topBoxes() -> [SupplyBox] {
        (0..<width).compactMap { y in
            let topIdx = topIndex(column: y)
            return value(at: Coordinate(x: topIdx, y: y))
        }
    }

    /// Assign to the stacks the given box, accessed via the coordinate.
    mutating func assign(_ coord: Coordinate, box: SupplyBox) {
        guard valid(coordinate: coord) else { return }
        stack[coord.x][coord.y] = box
    }

    /// Clears the given coordinate space within the stacks
    mutating func clear(_ coord: Coordinate) {
        assign(coord, box: .empty)
    }

    /// Print out the current stack
    func printStack() {
        var output = ""
        (0..<height).forEach { x in
            var row = ""
            (0..<width).forEach { y in
                let coord = Coordinate(x: x, y: y)
                let box = value(at: coord)

                if case .box(let name) = box {
                    row += "[\(name)] "
                } else {
                    row += "    "
                }
            }
            output += (row + "\n")
        }
        print(output)
    }


    // MARK: - Static Methods

    /// Parse the given input into the stack of boxes and instructions
    static func parse(_ input: String?) -> SupplyCrateMap {
        let lines = (input ?? "").split(separator: "\n").map(String.init)

        var stack = SupplyCrateStack()

        var indexLineIdx = 0
        for (idx, line) in lines.enumerated() {
            if let _ = line.firstMatch(of: indexLineRegex) {
                indexLineIdx = idx
                break
            } else {
                let boxMatches = line.matches(of: boxColumnRegex)

                if boxMatches.count > 0 {
                    let row: [SupplyCrateMap.SupplyBox] = boxMatches.map { match in
                        if let boxName = match.1 {
                            return .box(String(boxName))
                        } else {
                            return .empty
                        }
                    }

                    guard !row.isEmpty else { break }
                    stack.append(row)
                }
            }
        }
        stack = equalize(stack: stack) // make sure all rows are the same length

        let instructions = lines.suffix(from: indexLineIdx).compactMap { line -> Instruction? in
            guard let match = line.firstMatch(of: instructionRegex) else { return nil }
            guard let move = Int(match.1), let startIdx = Int(match.2), let endIdx = Int(match.3) else { return nil }
            return Instruction(moveAmount: move, originIndex: startIdx, destinationIndex: endIdx)
        }

        return SupplyCrateMap(stack: stack, instructions: instructions)
    }

    /// Make sure all rows have an equal width
    static func equalize(stack: SupplyCrateStack) -> SupplyCrateStack {
        var updated = SupplyCrateStack()

        guard let maxLength = stack.map(\.count).max() else { return stack }

        for row in stack {
            if row.count == maxLength {
                updated.append(row)
            } else {
                var updatedRow = row
                updatedRow.append(contentsOf: Array(repeating: .empty, count: maxLength - row.count))
                updated.append(updatedRow)
            }
        }

        return updated
    }


    // MARK: - Regex

    static let boxRegex = Regex {
        One("[")
        Capture {
            One(.word)
        }
        One("]")
    }

    static let boxColumnRegex = Regex {
        ChoiceOf {
            boxRegex

            Repeat(count: 3) {
                One(.whitespace)
            }
        }
        Optionally(.whitespace)
    }

    static let indexLineRegex = Regex {
        OneOrMore {
            OneOrMore(.whitespace)
            OneOrMore(.digit)
        }
    }

    static let instructionRegex = Regex {
        "move "
        Capture {
            OneOrMore(.digit)
        }
        " from "
        Capture {
            OneOrMore(.digit)
        }
        " to "
        Capture {
            OneOrMore(.digit)
        }
    }

}
