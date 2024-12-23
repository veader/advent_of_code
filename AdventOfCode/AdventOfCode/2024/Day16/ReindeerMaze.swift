//
//  ReindeerMaze.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/16/24.
//

import Foundation

class ReindeerMaze {
    enum MazeItem: String {
        case wall = "#"
        case start = "S"
        case end = "E"
        case space = "."
        case occupied = "O"
    }

    let maze: GridMap<MazeItem>
    let start: Coordinate
    let end: Coordinate

    let turnCost: Int

    var position: Coordinate = .origin
    var orientation: RelativeDirection = .east

    init?(input: String, turnCost: Int = 1000) {
        let mazeData: [[MazeItem]] = input.lines().map { line in
            line.charSplit().compactMap { MazeItem(rawValue: $0) }
        }
        self.maze = GridMap(items: mazeData)

        guard
            let theStart = maze.first(where: { $0 == .start }),
            let theEnd = maze.first(where: { $0 == .end })
        else { return nil }

        self.start = theStart
        self.end = theEnd
        self.turnCost = turnCost
    }

    func crawlMaze() -> MazeScore? {
        let startingVector = Vector(location: start, direction: .east)
        let startingScore = MazeScore(turns: 0, path: [startingVector], turnCost: turnCost)

        var spotsToCheck: [MazeScore] = [startingScore]
        var visited: [Coordinate: MazeScore] = [:]
        visited[start] = startingScore

        while !spotsToCheck.isEmpty {
            //print("Visited: \(visited.count) | To Check: \(spotsToCheck.count)")
            let spot = spotsToCheck.removeFirst()

            // check adjacent neighbors that are spaces (that haven't been visited?)
            //  - should we check to see if our vector is better than the current visited?
            let adjacentSpaces = maze.adjacentCoordinates(to: spot.location, allowDiagonals: false).filter { maze.item(at: $0) != .wall }

            for space in adjacentSpaces {
                var newScore = spot

                let direction = spot.location.direction(to: space, originTopLeft: true)
                if direction == spot.direction.opposite {
                    // turn twice
                    newScore = newScore.turningClockwise()
                    newScore = newScore.turningClockwise()
                } else if direction == spot.direction.rotated90 {
                    // turn once, clockwise
                    newScore = newScore.turningClockwise()
                } else if direction == spot.direction.ccwRotation90 {
                    // turn once, counter-clockwise
                    newScore = newScore.turningCounterClockwise()
                } // else - no direction change

                // move to the space
                newScore = newScore.moving(to: space)

                // determine if we need to update (or set) the score for this space
                var updatedScore = false
                if let spaceCurrentScore = visited[space] {
                    // update this space (even if visited), if this new path is "cheaper"
                    if newScore.score < spaceCurrentScore.score {
                        visited[space] = newScore
                        updatedScore = true
// Part 2 Idea: Find any place where we get to the same point with the same score?
//                    } else if spaceCurrentScore.score == newScore.score {
//                        print("Possible other path along this route...")
                    }
                } else {
                    visited[space] = newScore
                    updatedScore = true
                }

                // loop checking out this space if it's not the end
                if updatedScore && space != end {
                    spotsToCheck.append(newScore)
                }
            }
        }

        guard let endScore = visited[end] else { return nil }
        return endScore
    }


    func printMaze() {
        print(maze.gridAsString(transform: { $0?.rawValue ?? " " }))
    }


    // MARK: -

    struct MazeScore {
        /// The number of turns made to reach this score
        let turns: Int

        /// The number of steps made to reach this score
        let path: [Vector]

        /// The cost of taking a turn when scoring
        let turnCost: Int

        /// The score based on turns and path
        var score: Int { (turns * turnCost) + (path.count - 1) } // remove start or end (depending on how you view the world)

        /// The direction should be based on the last element of the path. (Defaults to East)
        var direction: RelativeDirection { path.last?.direction ?? .east }

        /// The location should be based on the last element of the path.
        var location: Coordinate { path.last?.location ?? .origin }

        /// Return a new maze score by turning 90º clockwise
        /// - Warning: Because I'm lazy, I'm force unwrapping where I usually wouldn't.
        func turningClockwise() -> MazeScore {
            let vector = path.last!
            let newVector = Vector(location: vector.location, direction: vector.direction.rotated90)
            return MazeScore(turns: turns + 1, path: path.dropLast() + [newVector], turnCost: turnCost)
        }

        /// Return a new maze score by turning 90º counter-clockwise
        /// - Warning: Because I'm lazy, I'm force unwrapping where I usually wouldn't.
        func turningCounterClockwise() -> MazeScore {
            let vector = path.last!
            let newVector = Vector(location: vector.location, direction: vector.direction.ccwRotation90)
            return MazeScore(turns: turns + 1, path: path.dropLast() + [newVector], turnCost: turnCost)
        }

        /// Returns a new maze score by adding a new step along the path.
        ///
        /// - Note: Assumes travel in same current direction.
        /// - Warning: Because I'm lazy, I'm force unwrapping where I usually wouldn't.
        func moving(to location: Coordinate) -> MazeScore {
            let vector = path.last!
            let newVector = Vector(location: location, direction: vector.direction)
            return MazeScore(turns: turns, path: path + [newVector], turnCost: turnCost)
        }
    }
}
