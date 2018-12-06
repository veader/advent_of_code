//
//  DayFiveTests.swift
//  Test
//
//  Created by Shawn Veader on 12/5/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import XCTest

class DayFiveTests: XCTestCase {

    func testPolyParsingEasy() {
        let day = DayFive()

        XCTAssertEqual("", day.parseReactions(input: "aA"))
        XCTAssertEqual("AA", day.parseReactions(input: "AA"))

        XCTAssertEqual("aA", day.parseReactions(input: "abBA"))
        XCTAssertEqual("abAB", day.parseReactions(input: "abAB"))

        XCTAssertEqual("aabAAB", day.parseReactions(input: "aabAAB"))
    }

    func testPolyParsingHarder() {
        let day = DayFive()

        let start = "dabAcCaCBAcCcaDA"
        let end = "dabCBAcaDA"

        var next = day.parseReactions(input: start)
        XCTAssertEqual("dabAaCBAcaDA", next)
        next = day.parseReactions(input: next)
        XCTAssertEqual("dabCBAcaDA", next)

        // should do nothing
        next = day.parseReactions(input: next)
        XCTAssertEqual("dabCBAcaDA", next)

        XCTAssertEqual(end, next) // the end
    }

    func testRunPartOne() {
        let day = DayFive()
        let start = "dabAcCaCBAcCcaDA"
        if let answer = day.run(start, 1) as? Int {
            XCTAssertEqual(10, answer)
        } else {
            XCTFail("Unable to run Day 5 Part 1")
        }
    }
}
