//
//  DayTwelveTests.swift
//  Test
//
//  Created by Shawn Veader on 12/13/20.
//

import XCTest

class DayTwelveTests: XCTestCase {

    func testNavInstructionParsing() {
        var answer: NavInstruction?

        answer = NavInstruction("nope")
        XCTAssertNil(answer)

        answer = NavInstruction("N1")
        XCTAssertEqual(.moveNorth(distance: 1), answer)
        answer = NavInstruction("N11")
        XCTAssertEqual(.moveNorth(distance: 11), answer)

        answer = NavInstruction("S2")
        XCTAssertEqual(.moveSouth(distance: 2), answer)

        answer = NavInstruction("E3")
        XCTAssertEqual(.moveEast(distance: 3), answer)

        answer = NavInstruction("W4")
        XCTAssertEqual(.moveWest(distance: 4), answer)

        answer = NavInstruction("L90")
        XCTAssertEqual(.turnLeft(degrees: 90), answer)

        answer = NavInstruction("R180")
        XCTAssertEqual(.turnRight(degrees: 180), answer)

        answer = NavInstruction("F10")
        XCTAssertEqual(.moveForward(distance: 10), answer)
    }

    func testFerryTurn() {
        let ferry = Ferry(instructions: [])
        XCTAssertEqual(.east, ferry.facing)

        ferry.turn(degrees: 90)
        XCTAssertEqual(.south, ferry.facing)
        ferry.turn(degrees: 180)
        XCTAssertEqual(.north, ferry.facing)
        ferry.turn(degrees: 270)
        XCTAssertEqual(.west, ferry.facing)

        ferry.turn(degrees: -180)
        XCTAssertEqual(.east, ferry.facing)
        ferry.turn(degrees: -90)
        XCTAssertEqual(.north, ferry.facing)
        ferry.turn(degrees: -270)
        XCTAssertEqual(.east, ferry.facing)
    }

    func testFerryNavigation() {
        let day = DayTwelve()
        let navInstructions = day.parse(testNavigationInput)
        let ferry = Ferry(instructions: navInstructions!)
        ferry.navigate()
        XCTAssertEqual(25, ferry.distanceToOrigin())
    }

    func testFerryFollowWaypoint() {
        let day = DayTwelve()
        let navInstructions = day.parse(testNavigationInput)
        let ferry = Ferry(instructions: navInstructions!)
        ferry.followWaypoint()
        XCTAssertEqual(286, ferry.distanceToOrigin())
    }

    let testNavigationInput = """
        F10
        N3
        F7
        R90
        F11
        """
}
