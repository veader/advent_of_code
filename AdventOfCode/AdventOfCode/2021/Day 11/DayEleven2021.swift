//
//  DayEleven2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/11/21.
//

import Foundation

struct DayEleven2021: AdventDay {
    var year = 2021
    var dayNumber = 11
    var dayTitle = "Dumbo Octopus"
    var stars = 2

    func parse(_ input: String?) -> GridMap<Int> {
        let data: [[Int]] = (input ?? "").split(separator: "\n").map(String.init).map { $0.map(String.init).compactMap(Int.init) }
        return GridMap<Int>(items: data)
    }

    func partOne(input: String?) -> Any {
        let grid = parse(input)
        grid.printSize()
        return countFlashes(grid: grid, stepCount: 100)
    }

    func partTwo(input: String?) -> Any {
        let grid = parse(input)
        grid.printSize()
        return firstAllFlashed(grid: grid)
    }

    func firstAllFlashed(grid: GridMap<Int>) -> Int {
        var step = 0
        let fullCount = grid.coordinates().count
        var stepCount = runSingleStep(grid: grid)
        while stepCount != fullCount {
            step += 1
            stepCount = runSingleStep(grid: grid)
        }
        return step + 1
    }

    func countFlashes(grid: GridMap<Int>, stepCount: Int = 1) -> Int {
        guard stepCount > 0 else { return 0 }

        print("\nBefore any steps:")
        grid.printGrid()

        var flashedCount = 0

        for i in 0..<stepCount {
            /*
            var flashed = Set<Coordinate>() // locations which have already flashed this step
            var toFlash = Set<Coordinate>() // locations still needing to be flashed in this step

            // increment all values by 1
            grid.updateEach { $1 + 1 }

            // find initial set of coordinates that need to flash
            toFlash = Set(grid.filter(by: { $1 > 9 }))

            // loop through our set of locations to flash, "flash" them (adjusting
            //      adjacent values), repeat till none are left
            repeat {
                toFlash.forEach { coordinate in
                    flashedCount += 1
                    let adjacent = grid.adjacentCoordinates(to: coordinate)
                    adjacent.forEach { c in
                        grid.update(at: c) { $0 + 1 }
                    }

                    flashed.insert(coordinate)
                }

                // recalculate toFlash
                toFlash = Set(grid.filter(by: { $1 > 9 })).subtracting(flashed)
            } while !toFlash.isEmpty

            // find all values >= 9 and reset to 0
            let resetCoordinates = grid.filter(by: { $1 > 9 })
            resetCoordinates.forEach { grid.update(at: $0, with: 0) }
             */

            let updateCount = runSingleStep(grid: grid)
            flashedCount += updateCount

            print("After step \(i + 1)")
            grid.printGrid()
        }

        return flashedCount
    }

    func runSingleStep(grid: GridMap<Int>) -> Int {
        var flashedCount = 0
        var flashed = Set<Coordinate>() // locations which have already flashed this step
        var toFlash = Set<Coordinate>() // locations still needing to be flashed in this step

        // increment all values by 1
        grid.updateEach { $1 + 1 }

        // find initial set of coordinates that need to flash
        toFlash = Set(grid.filter(by: { $1 > 9 }))

        // loop through our set of locations to flash, "flash" them (adjusting
        //      adjacent values), repeat till none are left
        repeat {
            toFlash.forEach { coordinate in
                flashedCount += 1
                let adjacent = grid.adjacentCoordinates(to: coordinate)
                adjacent.forEach { c in
                    grid.update(at: c) { $0 + 1 }
                }

                flashed.insert(coordinate)
            }

            // recalculate toFlash
            toFlash = Set(grid.filter(by: { $1 > 9 })).subtracting(flashed)
        } while !toFlash.isEmpty

        // find all values >= 9 and reset to 0
        let resetCoordinates = grid.filter(by: { $1 > 9 })
        resetCoordinates.forEach { grid.update(at: $0, with: 0) }

        return flashedCount
    }
}
