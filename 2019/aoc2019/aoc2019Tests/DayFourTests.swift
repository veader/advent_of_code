//
//  DayFourTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/4/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DayFourTests: XCTestCase {

    func testIntPasswordExtension() {
        XCTAssertFalse(12345.validPassword)   // too short
        XCTAssertFalse(1234567.validPassword) // too long
        XCTAssertFalse(132456.validPassword)  // not ascending
        XCTAssertFalse(223450.validPassword)  // not ascending
        XCTAssertFalse(123789.validPassword)  // no duplicate

        XCTAssertTrue(111111.validPassword)
        XCTAssertTrue(223456.validPassword)
        XCTAssertTrue(234456.validPassword)
    }

    func testPartTwoIntExtension() {
        XCTAssertTrue(112233.extraValidPassword)
        XCTAssertTrue(111122.extraValidPassword)

        XCTAssertFalse(123444.extraValidPassword) // 4 repeats but not pair
    }

    func testCollectionExtension() {
        let collection = [1,1,2,3,3,3,4,5]
        let dupSequences = collection.duplicateSubSequences()
        print(dupSequences)
        XCTAssertEqual(2, dupSequences.count)
        XCTAssertEqual([1,1], dupSequences.first)
        XCTAssertEqual([3,3,3], dupSequences.last)
    }

    // NOTE: these take a few seconds, commenting them out for speed
    func testPartOneAnswer() {
        XCTAssert(true)
//        let day = DayFour()
//        let answer = day.run(part: 1) as! Int
//        XCTAssertEqual(1625, answer)
    }

    func testPartTwoAnswer() {
        XCTAssert(true)
//        let day = DayFour()
//        let answer = day.run(part: 2) as! Int
//        XCTAssertEqual(1111, answer)
    }
}
