//
//  DigMap.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/26/23.
//

import Foundation

class DigMap {
    let instructions: [DiggingInstruction]
    var grid: GridMap<String>

    init(instructions: [DiggingInstruction]) {
        self.instructions = instructions

        var current: Coordinate = .origin // starting coordinate
        var coordinates: Set<Coordinate> = [current]

        for inst in instructions {
            let relDir = inst.direction.direction
            for _ in (0..<inst.distance) {
                current = current.moving(direction: relDir, originTopLeft: true)
                coordinates.insert(current)
            }
        }

        print(coordinates.count)

        // find deltas for coordinate adjustments
        let xs = coordinates.map(\.x).sorted()
        let xMin = xs.min() ?? 0
        let xMax = xs.max() ?? 0
        let xDelta = 0 - xMin

        let ys = coordinates.map(\.y).sorted()
        let yMin = ys.min() ?? 0
        let yMax = ys.max() ?? 0
        let yDelta = 0 - yMin
        print("X: \(xMin) - \(xMax): Delta: \(xDelta)")
        print("Y: \(yMin) - \(yMax): Delta: \(yDelta)")

        let xRange = xMax - xMin
        let emptyState = (yMin...yMax).map { _ in
            Array(repeating: ".", count: xRange+1)
        }

        grid = GridMap<String>(items: emptyState)
        for c in coordinates {
            let shifted = Coordinate(x: c.x + xDelta, y: c.y + yDelta)
            grid.update(at: shifted, with: "#")
        }
        grid.printGrid()
    }

    func dig() {
        for c in grid.coordinates() {
            guard grid.item(at: c) == "." else { continue }
            //
        }
    }
}
