//
//  OceanFloor.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/5/21.
//

import Foundation

class OceanFloor {
    let ventLines: [Line]
    var floorMap = [Coordinate: Int]()

    init(lines: [Line], ignoreDiagonals: Bool = true) {
        self.ventLines = lines
        createMap(ignoreDiagonals: ignoreDiagonals)
    }

    func createMap(ignoreDiagonals: Bool) {
        ventLines.forEach { line in
            if ignoreDiagonals && !line.isVertical && !line.isHorizontal {
                print("Ignoring diagonal line: \(line)")
                return
            }

            line.points().forEach { c in
                floorMap[c] = (floorMap[c] ?? 0) + 1
            }
        }
    }

    /// Points in the map where there are 2 (or more) intersecting vents
    func overlapPoints() -> [Coordinate] {
        floorMap.filter({ $0.value > 1 }).map(\.key)
    }

    var xLimits: ClosedRange<Int> {
        let coordinates = ventLines.flatMap { [$0.start, $0.end] }
        let xs = coordinates.map(\.x)
        return (xs.min() ?? 0)...(xs.max() ?? 0)
    }

    var yLimits: ClosedRange<Int> {
        let coordinates = ventLines.flatMap { [$0.start, $0.end] }
        let ys = coordinates.map(\.y)
        return (ys.min() ?? 0)...(ys.max() ?? 0)
    }
}

extension OceanFloor: CustomDebugStringConvertible {
    var debugDescription: String {
        var output = [String]()
        let xRange = xLimits
        let yRange = yLimits

        yRange.forEach { y in
            var row = [String]()
            xRange.forEach { x in
                if let mapValue = floorMap[Coordinate(x: x, y: y)] {
                    row.append("\(mapValue)")
                } else {
                    row.append(".")
                }
            }
            output.append(row.joined())
        }

        return output.joined(separator: "\n")
    }
}
