//
//  MazeTests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/24/24.
//

import Testing

struct MazeTests {

    @Test func testTurningMazeScoreCW() async throws {
        let score = Maze.MazeScore(turns: 0, path: [Vector(location: .origin, direction: .north)], turnCost: 1)

        let oneTurn = score.turningClockwise()
        #expect(oneTurn.location == .origin)
        #expect(oneTurn.path.count == 1)
        #expect(oneTurn.turns == 1)
        #expect(oneTurn.direction == .east)

        let twoTurns = score.turningClockwise(count: 2)
        #expect(twoTurns.location == .origin)
        #expect(twoTurns.path.count == 1)
        #expect(twoTurns.turns == 2)
        #expect(twoTurns.direction == .south)

        let threeTurns = score.turningClockwise(count: 3)
        #expect(threeTurns.location == .origin)
        #expect(threeTurns.path.count == 1)
        #expect(threeTurns.turns == 3)
        #expect(threeTurns.direction == .west)

        let fourTurns = score.turningClockwise(count: 4)
        #expect(fourTurns.location == .origin)
        #expect(fourTurns.path.count == 1)
        #expect(fourTurns.turns == 0)
        #expect(fourTurns.direction == .north)

        let fiveTurns = score.turningClockwise(count: 5)
        #expect(fiveTurns.location == .origin)
        #expect(fiveTurns.path.count == 1)
        #expect(fiveTurns.turns == 1)
        #expect(fiveTurns.direction == .east)
    }

    @Test func testTurningMazeScoreCCW() async throws {
        let score = Maze.MazeScore(turns: 0, path: [Vector(location: .origin, direction: .north)], turnCost: 1)

        let oneTurn = score.turningCounterClockwise()
        #expect(oneTurn.location == .origin)
        #expect(oneTurn.path.count == 1)
        #expect(oneTurn.turns == 1)
        #expect(oneTurn.direction == .west)

        let twoTurns = score.turningCounterClockwise(count: 2)
        #expect(twoTurns.location == .origin)
        #expect(twoTurns.path.count == 1)
        #expect(twoTurns.turns == 2)
        #expect(twoTurns.direction == .south)

        let threeTurns = score.turningCounterClockwise(count: 3)
        #expect(threeTurns.location == .origin)
        #expect(threeTurns.path.count == 1)
        #expect(threeTurns.turns == 3)
        #expect(threeTurns.direction == .east)

        let fourTurns = score.turningCounterClockwise(count: 4)
        #expect(fourTurns.location == .origin)
        #expect(fourTurns.path.count == 1)
        #expect(fourTurns.turns == 0)
        #expect(fourTurns.direction == .north)

        let fiveTurns = score.turningCounterClockwise(count: 5)
        #expect(fiveTurns.location == .origin)
        #expect(fiveTurns.path.count == 1)
        #expect(fiveTurns.turns == 1)
        #expect(fiveTurns.direction == .west)
    }

}
