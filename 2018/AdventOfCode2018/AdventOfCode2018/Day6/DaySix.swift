//
//  DaySix.swift
//  AdventOfCode2018
//
//  Created by Shawn Veader on 12/6/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import Foundation

struct DaySix: AdventDay {
    var dayNumber: Int = 6

    struct Grid {
        let locations: [Coordinate]
        let minX: Int
        let maxX: Int
        let minY: Int
        let maxY: Int

        // Grid of each coordinate and the location it is
        //      closest to based on Manhattan distances.
        var grid: [Coordinate: Coordinate]

        /// Grid of each coordinate and the distance to the
        ///     sum distances to each location.
        var sumsGrid: [Coordinate: Int]

        init(coordinates: [Coordinate], overage: Int = 20) {
            self.locations = coordinates.enumerated().map { Coordinate(coordinate: $1, name: "\($0)") }

            grid = [Coordinate: Coordinate]()
            sumsGrid = [Coordinate: Int]()

            minX = (coordinates.map { $0.x }.min() ?? 0) - overage
            maxX = (coordinates.map { $0.x }.max() ?? 0) + overage
            minY = (coordinates.map { $0.y }.min() ?? 0) - overage
            maxY = (coordinates.map { $0.y }.max() ?? 0) + overage
        }

        mutating func calculateDistances() {
            for y in minY..<maxY+1 {
                for x in minX..<maxX+1 {
                    let coordinate = Coordinate(x: x, y: y)

                    // calculate the distances to each of our locations
                    let distances = locations.map { c -> (distance: Int, coordinate: Coordinate) in
                        let distance = c.distance(to: coordinate)
                        return (distance: distance, coordinate: c)
                    }

                    if let minDistance = distances.min(by: { $0.distance < $1.distance}) {
                        let matches = distances.filter { $0.distance == minDistance.distance }

                        // if we have more than one location that shares this minimum distance, don't mark either
                        if matches.count == 1 {
                            grid[coordinate] = minDistance.coordinate
                        }
                    }
                }
            }
        }

        mutating func calculateDistanceSums() {
            for y in minY..<maxY+1 {
                for x in minX..<maxX+1 {
                    let coordinate = Coordinate(x: x, y: y)

                    let sum = locations.map { coordinate.distance(to: $0) }
                                       .reduce(0, +)

                    sumsGrid[coordinate] = sum
                }
            }
        }

        func printCoordinateGrid() -> String {
            var output = ""

            for y in minY..<maxY+1 {
                var rowText = ""
                for x in minX..<maxX+1 {
                    let coordinate = Coordinate(x: x, y: y)
                    if locations.contains(coordinate) {
                        rowText.append("X")
                    } else {
                        rowText.append(".")
                    }
                }
                output.append("\(rowText)\n")
            }

            return output
        }

        func printDistanceGrid() -> String {
            var output = ""

            for y in minY..<maxY+1 {
                var rowText = ""
                for x in minX..<maxX+1 {
                    let coordinate = Coordinate(x: x, y: y)
                    if locations.contains(coordinate) {
                        // mark locations by X
                        rowText.append("X")
                    } else {
                        // display which location this closest to
                        if let value = grid[coordinate] {
                            rowText.append(value.name ?? "?")
                        } else {
                            rowText.append(".")
                        }
                    }
                }
                output.append("\(rowText)\n")
            }

            return output
        }

        func printSumGrid(lessThan: Int) -> String {
            var output = ""

            for y in minY..<maxY+1 {
                var rowText = ""
                for x in minX..<maxX+1 {
                    let coordinate = Coordinate(x: x, y: y)
                    if locations.contains(coordinate) {
                        rowText.append("X")
                    } else {
                        if let sum = sumsGrid[coordinate], sum < lessThan {
                            rowText.append("#")
                        } else {
                            rowText.append(".")
                        }
                    }
                }
                output.append("\(rowText)\n")
            }

            return output
        }


        func area(of location: Coordinate) -> Int {
            return grid.filter { $1 == location }.count
        }

        func area(lessThan: Int) -> Int {
            return sumsGrid.filter { $1 < lessThan }.count
        }

        /// Determine the location with the largest area (based on distance)
        /// that isn't infinite.
        ///
        /// - note: Defining locations with infinite areas as ones that touch
        ///         the bounds of our grid
        func largestArea() -> Int {
            let nonInfinteLocations = locations.filter {
                return  grid[Coordinate(x: $0.x, y: minY)] != $0 &&
                        grid[Coordinate(x: $0.x, y: maxY)] != $0 &&
                        grid[Coordinate(x: minX, y: $0.y)] != $0 &&
                        grid[Coordinate(x: maxX, y: $0.y)] != $0
            }

            return nonInfinteLocations.map({ area(of: $0) }).max() ?? Int.min
        }
    }

    @discardableResult func run(_ input: String? = nil, _ part: Int? = 1) -> Any {
        guard let input = input ?? defaultInput else {
            print("Day \(dayNumber): NO INPUT")
            exit(10)
        }

        let coordinates = process(input: input)
        let grid = Grid(coordinates: coordinates)

        if part == 1 {
            let answer = partOne(grid: grid)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        } else {
            let answer = partTwo(grid: grid)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        }
    }

    func partOne(grid: Grid) -> Int {
        var theGrid = grid
        theGrid.calculateDistances()
        return theGrid.largestArea()
    }

    func partTwo(grid: Grid) -> Int {
        var theGrid = grid
        theGrid.calculateDistanceSums()
        return theGrid.area(lessThan: 10000)
    }

    func process(input: String) -> [Coordinate] {
        return input.split(separator: "\n")
            .map(String.init)
            .compactMap {
                let pieces = $0.split(separator: ",")
                    .map(String.init)
                    .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

                guard pieces.count == 2,
                    let x = pieces.first,
                    let y = pieces.last
                    else { return nil }

                return Coordinate(x: x, y: y)
            }
    }

}
