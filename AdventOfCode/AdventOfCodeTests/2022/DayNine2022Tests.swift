//
//  DayNine2022Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/9/22.
//

import XCTest

final class DayNine2022Tests: XCTestCase {

    let sampleInput = """
        R 4
        U 4
        L 3
        D 1
        R 4
        D 1
        L 5
        R 2
        """

    let largerSampleInput = """
        R 5
        U 8
        L 8
        D 3
        R 17
        D 10
        L 25
        U 20
        """

    func testParsing() {
        let sim = RopeSimulator(sampleInput)
        XCTAssertEqual(8, sim.instructions.count)
        XCTAssertEqual(Coordinate.origin, sim.knots.first)
        XCTAssertEqual(Coordinate.origin, sim.knots.last)
        XCTAssertEqual(1, sim.visitedCoordinates.count)
    }

    func testSimpleInstruction() {
        let sim = RopeSimulator("R 4")
        XCTAssertEqual(1, sim.instructions.count)
        sim.run()

        XCTAssertEqual(Coordinate(x: 4, y: 0), sim.knots.first)
        XCTAssertEqual(Coordinate(x: 3, y: 0), sim.knots.last)
        XCTAssertEqual(4, sim.visitedCoordinates.count)
    }

    func testInstruction() {
        let sim = RopeSimulator(sampleInput)
        XCTAssertEqual(8, sim.instructions.count)
        sim.run()

        XCTAssertEqual(Coordinate(x: 2, y: 2), sim.knots.first)
        XCTAssertEqual(Coordinate(x: 1, y: 2), sim.knots.last)
        XCTAssertEqual(13, sim.visitedCoordinates.count)
//        sim.printIteration(showingVisited: true)
    }

    func testPartOne() {
        let answer = DayNine2022().partOne(input: sampleInput)
        XCTAssertEqual(13, answer as! Int)
    }

    func testInstructionsMoreKnots() {
        let sim = RopeSimulator(sampleInput, length: 10)
        XCTAssertEqual(8, sim.instructions.count)
        sim.run()

        XCTAssertEqual(Coordinate(x: 2, y: 2), sim.knots.first)
        XCTAssertEqual(Coordinate(x: 0, y: 0), sim.knots.last)
        XCTAssertEqual(1, sim.visitedCoordinates.count)
//        sim.printIteration(showingVisited: true)
    }

    func testInstructionsLargerInput() {
        let sim = RopeSimulator(largerSampleInput, length: 10)
        XCTAssertEqual(8, sim.instructions.count)
        sim.run()

        XCTAssertEqual(Coordinate(x: -11, y: 15), sim.knots.first)
        XCTAssertEqual(Coordinate(x: -11, y: 6), sim.knots.last)
        XCTAssertEqual(36, sim.visitedCoordinates.count)
        sim.printIteration(showingVisited: true)
    }

    func testRelativeCoordinateDirection() {
        var answer: Coordinate.RelativeDirection

        // Same
        answer = Coordinate.origin.direction(to: Coordinate.origin)
        XCTAssertEqual(.same, answer)

        // East
        answer = Coordinate.origin.direction(to: Coordinate(x: 1, y: 0))
        XCTAssertEqual(.east, answer)
        answer = Coordinate.origin.direction(to: Coordinate(x: 2, y: 0))
        XCTAssertEqual(.east, answer)

        // West
        answer = Coordinate.origin.direction(to: Coordinate(x: -1, y: 0))
        XCTAssertEqual(.west, answer)

        // North
        answer = Coordinate.origin.direction(to: Coordinate(x: 0, y: 1))
        XCTAssertEqual(.north, answer)
        answer = Coordinate.origin.direction(to: Coordinate(x: 0, y: 2))
        XCTAssertEqual(.north, answer)

        // South
        answer = Coordinate.origin.direction(to: Coordinate(x: 0, y: -2))
        XCTAssertEqual(.south, answer)

        // NorthEast
        answer = Coordinate.origin.direction(to: Coordinate(x: 1, y: 1))
        XCTAssertEqual(.northEast, answer)
        answer = Coordinate.origin.direction(to: Coordinate(x: 2, y: 1))
        XCTAssertEqual(.northEast, answer)
        answer = Coordinate.origin.direction(to: Coordinate(x: 1, y: 2))
        XCTAssertEqual(.northEast, answer)

        // SouthEast
        answer = Coordinate.origin.direction(to: Coordinate(x: 1, y: -1))
        XCTAssertEqual(.southEast, answer)
        answer = Coordinate.origin.direction(to: Coordinate(x: 2, y: -1))
        XCTAssertEqual(.southEast, answer)
        answer = Coordinate.origin.direction(to: Coordinate(x: 1, y: -2))
        XCTAssertEqual(.southEast, answer)

        // NorthWest
        answer = Coordinate.origin.direction(to: Coordinate(x: -1, y: 1))
        XCTAssertEqual(.northWest, answer)
        answer = Coordinate.origin.direction(to: Coordinate(x: -2, y: 1))
        XCTAssertEqual(.northWest, answer)
        answer = Coordinate.origin.direction(to: Coordinate(x: -1, y: 2))
        XCTAssertEqual(.northWest, answer)

        // SouthWest
        answer = Coordinate.origin.direction(to: Coordinate(x: -1, y: -1))
        XCTAssertEqual(.southWest, answer)
        answer = Coordinate.origin.direction(to: Coordinate(x: -2, y: -1))
        XCTAssertEqual(.southWest, answer)
        answer = Coordinate.origin.direction(to: Coordinate(x: -1, y: -2))
        XCTAssertEqual(.southWest, answer)
    }
}
