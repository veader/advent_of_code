//
//  DayTwentyFour.swift
//  aoc2019
//
//  Created by Shawn Veader on 1/4/20.
//  Copyright © 2020 Shawn Veader. All rights reserved.
//

import Foundation

struct DayTwentyFour: AdventDay {
    var dayNumber: Int = 24

    func parse(_ input: String?) -> BugGrid {
        var bugLocations = [Coordinate]()
        let lines = (input ?? "").split(separator: "\n").map(String.init)

        for (y, line) in lines.enumerated() {
            for (x, gridSpace) in line.map(String.init).enumerated() {
                if gridSpace == "#" {
                    let coordinate = Coordinate(x: x, y: y)
                    bugLocations.append(coordinate)
                }
            }
        }

        return BugGrid(bugs: bugLocations)
    }

    func findDuplicateGrid(starter: BugGrid) -> BugGrid {
        var iteration = 0
        var grid = starter

        var previousGrids = Set<String>()
        previousGrids.insert(grid.description)

        while true {
            print("After \(iteration) minutes:")
            print(grid)

            iteration += 1
            grid = grid.increment()

            if previousGrids.contains(grid.description) {
                print("Found duplicate @ \(iteration):\n\(grid.description)")
                break
            } else {
                previousGrids.insert(grid.description)
            }
        }

        return grid
    }

    func partOne(input: String?) -> Any {
        let grid = parse(input)
        let dupeGrid = findDuplicateGrid(starter: grid)
        return dupeGrid.biodiversityRating()
    }

    func partTwo(input: String?) -> Any {
        let grid = parse(input)
        let rGrid = RecursiveBugGrid(other: grid)

        var nextRGrid = rGrid

        for i in 0..<200 {
            print("Iteration \(i) - \(Date())")
            nextRGrid = nextRGrid.increment()
        }

        print(nextRGrid)
        return nextRGrid.bugs.count
    }
}
