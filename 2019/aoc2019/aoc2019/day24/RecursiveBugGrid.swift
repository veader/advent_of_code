//
//  RecursiveBugGrid.swift
//  aoc2019
//
//  Created by Shawn Veader on 1/4/20.
//  Copyright © 2020 Shawn Veader. All rights reserved.
//

import Foundation

struct RecursiveBugGrid {
    private let size = 5 // 5x5 grid

    /// Location of the bugs within this recursive grid
    let bugs: [DepthCoordinate]

    /// Increment the recursive grid(s) by one step in time...
    func increment() -> RecursiveBugGrid {
        var newBugLocations = [DepthCoordinate]()

        let centerCoord = Coordinate(x: 2, y: 2)

        let depths = bugs.map { $0.depth }.unique().sorted()
        // min and max should be one more to allow infestations of other depths
        let minDepth = (depths.min() ?? 0) - 1
        let maxDepth = (depths.max() ?? 0) + 1

        for depth in minDepth...maxDepth {
            for y in (0..<size) {
                for x in (0..<size) {
                    let coordinate = Coordinate(x: x, y: y)
                    if coordinate == centerCoord {
                        // don't try to do anything in the center...
                        continue
                    }

                    let dCoord = DepthCoordinate(depth: depth, coordinate: coordinate)
//                    print("Evaluating: \(dCoord)")
//                    print("\tAdjacent: \(dCoord.adjacent(size: size))")

                    let adjacent = dCoord.adjacent(size: size).filter { bugs.contains($0) }
//                    print("\tInfected Adjacent: \(adjacent)")
                    // TODO: shouldn't have the center in our list...

                    if bugs.contains(dCoord) { // infected space
//                        print("\tInfected Space -> \(adjacent.count)")
                        if adjacent.count == 1 {
                            newBugLocations.append(dCoord)
                        }
                    } else { // empty space
//                        print("\tEmpty Space -> \(adjacent.count)")
                        if adjacent.count == 1 || adjacent.count == 2 {
                            newBugLocations.append(dCoord)
                        }
                    }
                } // for(x)
            } // for(y)
        } // for(depth)

        return RecursiveBugGrid(bugs: newBugLocations)
    }
}

extension RecursiveBugGrid {
    /// Create a recursive BugGrid with a base (depth 0) set of bugs.
    init(bugs: [Coordinate]) {
        self.bugs = bugs.map { DepthCoordinate(depth: 0, coordinate: $0) }
    }

    /// Create a recursive BugGrid with a base (depth 0) set of bugs from a BugGrid.
    init(other grid: BugGrid) {
        self.bugs = grid.bugs.map { DepthCoordinate(depth: 0, coordinate: $0) }
    }
}

extension RecursiveBugGrid: CustomStringConvertible {
    var description: String {
        let centerCoord = Coordinate(x: 2, y: 2)
        let depths = bugs.map { $0.depth }.unique().sorted()
        let minDepth = depths.min() ?? 0
        let maxDepth = depths.max() ?? 0

        var output = ""

        for depth in minDepth...maxDepth {
            output += "Depth \(depth):\n"
            for y in 0..<size {
                for x in 0..<size {
                    let dCoord = DepthCoordinate(depth: depth, coordinate: Coordinate(x: x, y: y))

                    if dCoord.coordinate == centerCoord {
                        output += "?"
                    } else if bugs.contains(dCoord) {
                        output += "#"
                    } else {
                        output += "."
                    }
                }
                output += "\n"
            }
            output += "\n"
        }

        return output
    }
}
