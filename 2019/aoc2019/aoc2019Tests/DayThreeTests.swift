//
//  DayThreeTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/3/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DayThreeTests: XCTestCase {

    func testPartOne() {
        var day = DayThree()
        var input = """
                    R8,U5,L5,D3
                    U7,R6,D4,L4
                    """

        var answer = day.run(part: 1, input) as! Int
        XCTAssertEqual(6, answer)

        day = DayThree()
        input = """
                R75,D30,R83,U83,L12,D49,R71,U7,L72
                U62,R66,U55,R34,D71,R55,D58,R83
                """

        answer = day.run(part: 1, input) as! Int
        XCTAssertEqual(159, answer)

        day = DayThree()
        input = """
                R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
                U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
                """
        answer = day.run(part: 1, input) as! Int
        XCTAssertEqual(135, answer)
    }

    func testPartOneAnswer() {
        let day = DayThree()
        let answer = day.run(part: 1) as! Int
        XCTAssertEqual(1017, answer)
    }

    func testPartTwo() {
        var day = DayThree()
        var input = """
                    R8,U5,L5,D3
                    U7,R6,D4,L4
                    """

        var answer = day.run(part: 2, input) as! Int
        XCTAssertEqual(30, answer)

        day = DayThree()
        input = """
                R75,D30,R83,U83,L12,D49,R71,U7,L72
                U62,R66,U55,R34,D71,R55,D58,R83
                """

        answer = day.run(part: 2, input) as! Int
        XCTAssertEqual(610, answer)

        day = DayThree()
        input = """
                R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
                U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
                """
        answer = day.run(part: 2, input) as! Int
        XCTAssertEqual(410, answer)
    }

    func testPartTwoAnswer() {
        let day = DayThree()
        let answer = day.run(part: 2) as! Int
        XCTAssertEqual(11432, answer)
    }
}
