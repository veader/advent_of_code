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

    func testParsing() {
        let sim = RopeSimulator(sampleInput)
        XCTAssertEqual(8, sim.instructions.count)
        XCTAssertEqual(Coordinate.origin, sim.head)
        XCTAssertEqual(Coordinate.origin, sim.tail)
        XCTAssertEqual(1, sim.visitedCoordinates.count)
    }

    func testSimpleInstruction() {
        let sim = RopeSimulator("R 4")
        XCTAssertEqual(1, sim.instructions.count)
        sim.run()

        XCTAssertEqual(Coordinate(x: 4, y: 0), sim.head)
        XCTAssertEqual(Coordinate(x: 3, y: 0), sim.tail)
        XCTAssertEqual(4, sim.visitedCoordinates.count)
    }

    func testInstruction() {
        let sim = RopeSimulator(sampleInput)
        XCTAssertEqual(8, sim.instructions.count)
        sim.run()

        XCTAssertEqual(Coordinate(x: 2, y: 2), sim.head)
        XCTAssertEqual(Coordinate(x: 1, y: 2), sim.tail)
        XCTAssertEqual(13, sim.visitedCoordinates.count)
//        sim.printIteration(showingVisited: true)
    }

    func testPartOne() {
        let answer = DayNine2022().partOne(input: sampleInput)
        XCTAssertEqual(13, answer as! Int)
    }
}
