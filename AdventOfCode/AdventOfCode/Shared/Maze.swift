//
//  ReindeerMaze.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/16/24.
//

import Foundation

class Maze {
    /// Items within the Maze's `GridMap`
    enum MazeItem: String {
        case wall = "#"
        case start = "S"
        case end = "E"
        case space = "."
        case occupied = "O"
    }

    let grid: GridMap<MazeItem>
    let start: Coordinate
    let end: Coordinate

    let turnCost: Int

    var position: Coordinate = .origin
    var orientation: RelativeDirection = .east
    var width: Int { grid.width }
    var height: Int { grid.height }

    /// Create a `Maze` by parsing the given input.
    ///
    /// The start and end positions must be marked.
    init?(input: String, turnCost: Int = 1000) {
        let mazeData: [[MazeItem]] = input.lines().map { line in
            line.charSplit().compactMap { MazeItem(rawValue: $0) }
        }
        self.grid = GridMap(items: mazeData)

        guard
            let theStart = grid.first(where: { $0 == .start }),
            let theEnd = grid.first(where: { $0 == .end })
        else { return nil }

        self.start = theStart
        self.end = theEnd
        self.turnCost = turnCost
    }

    /// Crawl through the maze from the start to the end looking for the shortest path.
    ///
    /// - Returns: Resulting shortest path (if found) embedded in the `MazeScore`
    func crawlMaze() -> MazeScore? {
        let startingVector = Vector(location: start, direction: .east)
        let startingScore = MazeScore(turns: 0, path: [startingVector], turnCost: turnCost)

        var spotsToCheck: [MazeScore] = [startingScore]
        var visited: [Coordinate: MazeScore] = [:]
        visited[start] = startingScore

        while !spotsToCheck.isEmpty {
            let spot = spotsToCheck.removeFirst()

            // check adjacent neighbors that are spaces (that haven't been visited?)
            //  - should we check to see if our vector is better than the current visited?
            let adjacentSpaces = grid.adjacentCoordinates(to: spot.location, allowDiagonals: false).filter { grid.item(at: $0) != .wall }

            for space in adjacentSpaces {
                var newScore = spot

                let direction = spot.location.direction(to: space, originTopLeft: true)
                if direction == spot.direction.opposite {
                    // turn twice
                    newScore = newScore.turningClockwise(count: 2)
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

    /// Print the maze. (Using underlying `GridMap`)
    ///
    /// - Parameters:
    ///     - marking: `[Coordinate]` if given, the positions in this collection will be marked as occupied `O`
    func printMaze(marking: [Coordinate] = []) {
        print(grid.gridAsString(transform: {
            if marking.contains($0) {
                return MazeItem.occupied.rawValue
            } else {
                return $1?.rawValue ?? " "
            }
        }))
    }


    // MARK: -

    /// Score for maze solution (or partial). Captures path and number of turns.
    ///
    /// The turn cost is set within the Maze solving. Score is calculated by the
    /// number of turns multiplied by the turn cost and adding the number of steps
    /// taken in the path.
    ///
    /// Current location and direction are derived from the last step in the path.
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

        /// Return a new maze score by turning 90º clockwise (a given number of times)
        /// - Warning: Because I'm lazy, I'm force unwrapping where I usually wouldn't.
        func turningClockwise(count: Int = 1) -> MazeScore {
            let vector = path.last!
            let (newDirection, realTurns) = turning(direction: vector.direction, count: count, clockwise: true)
            let newVector = Vector(location: vector.location, direction: newDirection)
            return MazeScore(turns: turns + realTurns, path: path.dropLast() + [newVector], turnCost: turnCost)
        }

        /// Return a new maze score by turning 90º counter-clockwise
        /// - Warning: Because I'm lazy, I'm force unwrapping where I usually wouldn't.
        func turningCounterClockwise(count: Int = 1) -> MazeScore {
            let vector = path.last!
            let (newDirection, realTurns) = turning(direction: vector.direction, count: count, clockwise: false)
            let newVector = Vector(location: vector.location, direction: newDirection)
            return MazeScore(turns: turns + realTurns, path: path.dropLast() + [newVector], turnCost: turnCost)
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

        /// Starting in the given direction, rotate 90º the given number of times.
        /// Either clockwise or counter-clockwise...
        ///
        /// - Returns: Tuple with the new direction and the "real" number of turns taken.
        private func turning(direction: RelativeDirection, count: Int, clockwise: Bool) -> (RelativeDirection, Int) {
            // Determine how many real turns we need to make. Just 4 directions (given 90º)
            var realTurns = count % 4
            if realTurns == 4 {
                realTurns = 0
            }

            // turning this car around...
            var newDirection = direction
            var spins = 0
            while spins < realTurns {
                if clockwise {
                    newDirection = newDirection.rotated90
                } else {
                    newDirection = newDirection.ccwRotation90
                }
                spins += 1
            }

            return (newDirection, realTurns)
        }
    }
}
