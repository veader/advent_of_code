//
//  Day20_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/23/24.
//

import Foundation

struct Day20_2024: AdventDay {
    var year = 2024
    var dayNumber = 20
    var dayTitle = "Race Condition"
    var stars = 1

    func parse(_ input: String?) -> Maze? {
        Maze(input: input ?? "", turnCost: 0)
    }

    func partOne(input: String?) async-> Any {
        guard let maze = parse(input) else { return 0 }
        guard let solution = maze.crawlMaze() else { return 0 }
        let shortcuts = findShortcuts(maze: maze, score: solution)

        return shortcuts.count { $0.savings >= 100 }
    }

    func partTwo(input: String?) async -> Any {
        return 0
    }

    struct MazeShortcut {
        let point: Coordinate
        let wall: Coordinate
        let destination: Coordinate
        let originalSteps: Int
        let savings: Int
    }

    /// Find all shortcuts in the winning path (found in the `MazeScore`) for the maze.
    func findShortcuts(maze: Maze, score: Maze.MazeScore) -> [MazeShortcut] {
        var shortcuts = [MazeShortcut]()

        for vector in score.path {
            // not sure how this would never *NOT* work work ¯\_(ツ)_/¯
            guard let currentIdx = score.path.firstIndex(where: { $0.location == vector.location}) else { continue }

            // find any nearby walls (& directions to wall)
            let wallVectors = findWalls(maze: maze, at: vector.location)

            // see if any of the walls is blocking access to another point on the path
            wallVectors.forEach { v in
                let nextPoint = v.location.moving(direction: v.direction, originTopLeft: true)

                // look for a point further along the path...
                if score.path.contains(where: { $0.location == nextPoint }),
                   let destinationIdx = score.path.firstIndex(where: { $0.location == nextPoint }),
                   destinationIdx > currentIdx
                {
                    let originalDistance = destinationIdx - currentIdx
                    let savings = originalDistance - 2
                    let shortcut = MazeShortcut(point: vector.location,
                                                wall: v.location,
                                                destination: nextPoint,
                                                originalSteps: originalDistance,
                                                savings: savings)
                    shortcuts.append(shortcut)
//                    print("Saving \(savings) jumping from \(vector.location) to \(nextPoint) over the wall at \(v.location)")
                }
            }
        }

        return shortcuts
    }

    /// Find all walls surrounding the given point.
    ///
    /// - Returns: `[Vector]`  Each wall location and direction to that wall.
    func findWalls(maze: Maze, at coordinate: Coordinate) -> [Vector] {
        maze.grid.adjacentCoordinates(to: coordinate, allowDiagonals: false).filter {
            maze.grid.item(at: $0) == .wall
        }.map {
            let direction = coordinate.direction(to: $0, originTopLeft: true)
            return Vector(location: $0, direction: direction)
        }
    }
}
