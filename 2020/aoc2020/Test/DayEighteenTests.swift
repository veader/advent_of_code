//
//  DayEighteenTests.swift
//  Test
//
//  Created by Shawn Veader on 12/18/20.
//

import XCTest

class DayEighteenTests: XCTestCase {

    func testSimpleSolve() {
        let equation = MathEquation("1 + 2 * 3 + 4 * 5 + 6")
        let answer = equation.solve()
        XCTAssertEqual(71, answer)
    }

    func testParamSolve() {
        let equation = MathEquation("1 + (2 * 3) + (4 * (5 + 6)")
        let answer = equation.solve()
        XCTAssertEqual(51, answer)
    }

    func testOtherSolves() {
        var equation: MathEquation
        var answer: Int

        equation = MathEquation("2 * 3 + (4 * 5)")
        answer = equation.solve()
        XCTAssertEqual(26, answer)

        equation = MathEquation("5 + (8 * 3 + 9 + 3 * 4 * 3)")
        answer = equation.solve()
        XCTAssertEqual(437, answer)

        equation = MathEquation("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))")
        answer = equation.solve()
        XCTAssertEqual(12240, answer)

        equation = MathEquation("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2")
        answer = equation.solve()
        XCTAssertEqual(13632, answer)
    }

}
