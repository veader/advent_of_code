//
//  BugGrid.swift
//  aoc2019
//
//  Created by Shawn Veader on 1/4/20.
//  Copyright © 2020 Shawn Veader. All rights reserved.
//

import Foundation

struct BugGrid {
    let bugs: [Coordinate]

    private let size = 5 // 5x5 grid

    /// Increment the grid by one step in time...
    func increment() -> BugGrid {
        var newBugLocations = [Coordinate]()

        for y in (0..<size) {
            for x in (0..<size) {
                let coordinate = Coordinate(x: x, y: y)

                // find adjacent bugs
                let adjacent = coordinate.adjacent().filter { bugs.contains($0) }

                if bugs.contains(coordinate) { // infected space
                    if adjacent.count == 1 {
                        newBugLocations.append(coordinate)
                    }
                } else { // empty space
                    if adjacent.count == 1 || adjacent.count == 2 {
                        newBugLocations.append(coordinate)
                    }
                }
            }
        }

        return BugGrid(bugs: newBugLocations)
    }

    /// Biodiversity rating based on location of bugs.
    ///
    /// Bug coordinates are evaluated in
    func biodiversityRating() -> Int {
        bugs.reduce(0) { (sum, coordinate) -> Int in
            let addition = Int(pow(Double(2),
                                   Double((coordinate.y * size) + coordinate.x)))
            return sum + addition
        }
    }
}

extension BugGrid: CustomStringConvertible {
    var description: String {
        var output = ""

        for y in (0..<size) {
            for x in (0..<size) {
                let coordinate = Coordinate(x: x, y: y)
                if bugs.contains(coordinate) {
                    output += "#"
                } else {
                    output += "."
                }
            }
            output += "\n"
        }

        return output
    }
}
