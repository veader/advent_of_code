//
//  TransparentPaper.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/14/21.
//

import Foundation

class TransparentPaper {
    enum FoldInstruction: Equatable {
        case horizontal(x: Int)
        case vertical(y: Int)

        static func parse(_ input: String) -> FoldInstruction? {
            let prefix = "fold along "
            guard input.hasPrefix(prefix) else { return nil }

            let pieces = input.dropFirst(prefix.count).split(separator: "=").map(String.init)
            guard
                pieces.count == 2,
                let coordinate = pieces.first,
                let valueStr = pieces.last, let value = Int(valueStr)
            else { return nil }

            switch coordinate {
            case "x":
                return .horizontal(x: value)
            case "y":
                return .vertical(y: value)
            default:
                return nil
            }
        }
    }

    var dots: Set<Coordinate>
    let foldInsructions: [FoldInstruction]

    init(dots: [Coordinate], instructions: [FoldInstruction]) {
        self.dots = Set(dots)
        self.foldInsructions = instructions
    }

    static func parse(input: String) -> TransparentPaper {
        var dots = [Coordinate]()
        var instructions = [FoldInstruction]()

        input.split(separator: "\n").map(String.init).forEach { line in
            if line.hasPrefix("fold"), let inst = FoldInstruction.parse(line) {
                instructions.append(inst)
            } else if line.contains(","), let coord = Coordinate.parse(line) {
                dots.append(coord)
            }
        }

        return TransparentPaper(dots: dots, instructions: instructions)
    }

    /// Follow all instructions we have folding the paper as needed.
    func followInstructions() {
        foldInsructions.forEach { fold(direction: $0) }
    }

    /// Fold the coordinate space according to the given instruction.
    func fold(direction: FoldInstruction) {
        let currentDots = dots // copy
        currentDots.forEach { c in
            switch direction {
            case .vertical(y: let y):
                if c.y > y {
                    let newC = Coordinate(x: c.x, y: (y - (c.y - y)))
                    dots.remove(c)
                    dots.insert(newC)
                }
            case .horizontal(x: let x):
                if c.x > x {
                    let newC = Coordinate(x: (x - (c.x - x)), y: c.y)
                    dots.remove(c)
                    dots.insert(newC)
                }
            }
        }
    }
}

extension TransparentPaper: CustomDebugStringConvertible {
    var debugDescription: String {
        // find our bounds
        let xs = dots.map({ $0.x }).sorted()
        let ys = dots.map({ $0.y }).sorted()
        let xBounds = (xs.first ?? 0)...(xs.last ?? 100)
        let yBounds = (ys.first ?? 0)...(ys.last ?? 100)

        var output = [String]()
        yBounds.forEach { y in
            var row = [String]()
            xBounds.forEach { x in
                let c = Coordinate(x: x, y: y)
                if dots.contains(c) {
                    row.append("#")
                } else {
                    row.append(".")
                }
            }
            output.append(row.joined())
        }
        return output.joined(separator: "\n")
    }
}
