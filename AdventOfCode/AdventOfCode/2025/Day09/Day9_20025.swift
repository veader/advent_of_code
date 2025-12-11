//
//  Day9_20025.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/9/25.
//

import Foundation

struct Day9_2025: AdventDay {
    var year = 2025
    var dayNumber = 9
    var dayTitle = "Movie Theater"
    var stars = 1

    func parse(_ input: String?) -> [Coordinate] {
        (input ?? "").lines().compactMap { Coordinate($0) }
    }

    struct BoxPair: Comparable {
        let upperLeft: Coordinate
        let lowerRight: Coordinate
        let area: Int

        init(_ coord1: Coordinate, _ coord2: Coordinate) {
            let coordinates = [coord1, coord2].sorted()
            self.upperLeft = coordinates.first!
            self.lowerRight = coordinates.last!

            self.area = (abs(lowerRight.x - upperLeft.x) + 1) // width
                        *
                        (abs(lowerRight.y - upperLeft.y) + 1) // height
        }

        static func < (lhs: BoxPair, rhs: BoxPair) -> Bool {
            lhs.area < rhs.area
        }
    }

    func partOne(input: String?) -> Any {
        let coordinates = parse(input)

        // create pairs
        var pairs: [BoxPair] = []
        for (idx, c1) in coordinates.enumerated() {
            guard idx+1 < coordinates.count else { break }
            for c2 in coordinates[idx+1..<coordinates.count] {
                pairs.append(BoxPair(c1, c2))
            }
        }

        let sortedPairs = pairs.sorted(by: { $0.area > $1.area })

        return sortedPairs.first?.area ?? -1
    }

    func partTwo(input: String?) async -> Any {
        let coordinates = parse(input)

        enum FloorTile: String, CustomStringConvertible {
            case green = "X"
            case red = "#"
            case empty = "."

            var description: String { rawValue }
        }

        // find edges
        let lines: [GridLine] = coordinates.enumerated().map { idx, c in
            if (idx + 1) < coordinates.count {
                let c2 = coordinates[idx+1]
                return GridLine(start: c, end: c2)
            } else { // should be the end, so wrap around
                let c2 = coordinates[0]
                return GridLine(start: c, end: c2)
            }
        }


        // create our base map
        let maxX = coordinates.map(\.x).max() ?? 10
        let maxY = coordinates.map(\.y).max() ?? 10
        let map = GridMap<FloorTile>(width: maxX + 5, height: maxY + 5, initialValue: .empty)

        // map "green" edges
        for edge in lines {
            for c in edge.pointsAlongTheLine {
                map.update(at: c, with: .green)
            }
        }

        // map "red" coordinates
        for c in coordinates {
            map.update(at: c, with: .red)
        }

        // map.printGrid()
        // map.printGridByRow()

        return 0
    }
}
