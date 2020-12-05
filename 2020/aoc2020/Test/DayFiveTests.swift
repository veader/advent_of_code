//
//  DayFiveTests.swift
//  Test
//
//  Created by Shawn Veader on 12/5/20.
//

import XCTest

class DayFiveTests: XCTestCase {

    func testBoardingPassRowCalculation() {
        XCTAssertEqual(44, BoardingPass.calculate("FBFBBFF", totalItems: 128))
        XCTAssertEqual(70, BoardingPass.calculate("BFFFBBF", totalItems: 128))
        XCTAssertEqual(14, BoardingPass.calculate("FFFBBBF", totalItems: 128))
        XCTAssertEqual(102, BoardingPass.calculate("BBFFBBF", totalItems: 128))
    }

    func testBoardingPassColumnCalculation() {
        XCTAssertEqual(5, BoardingPass.calculate("RLR", totalItems: 8))
        XCTAssertEqual(7, BoardingPass.calculate("RRR", totalItems: 8))
        XCTAssertEqual(4, BoardingPass.calculate("RLL", totalItems: 8))
    }

    func testBoardingPassParsing() {
        var pass: BoardingPass?

        pass = BoardingPass("FBFBBFFRLR")
        XCTAssertNotNil(pass)
        XCTAssertEqual(44, pass?.row)
        XCTAssertEqual(5, pass?.column)
        XCTAssertEqual(357, pass?.seatID)

        pass = BoardingPass("BFFFBBFRRR")
        XCTAssertNotNil(pass)
        XCTAssertEqual(70, pass?.row)
        XCTAssertEqual(7, pass?.column)
        XCTAssertEqual(567, pass?.seatID)

        pass = BoardingPass("FFFBBBFRRR")
        XCTAssertNotNil(pass)
        XCTAssertEqual(14, pass?.row)
        XCTAssertEqual(7, pass?.column)
        XCTAssertEqual(119, pass?.seatID)

        pass = BoardingPass("BBFFBBFRLL")
        XCTAssertNotNil(pass)
        XCTAssertEqual(102, pass?.row)
        XCTAssertEqual(4, pass?.column)
        XCTAssertEqual(820, pass?.seatID)
    }

}
