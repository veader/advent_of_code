//
//  DayOneTests.swift
//  Test
//
//  Created by Shawn Veader on 12/2/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import XCTest

class DayOneTests: XCTestCase {

    func testPartOne() {
        let day = DayOne()

        var testInput = fix(input: "+1, -2, +3, +1")
        XCTAssertEqual(3, day.run(testInput) as? Int)

        testInput = fix(input: "+1,+1,+1")
        XCTAssertEqual(3, day.run(testInput) as? Int)

        testInput = fix(input: "+1,+1,-2")
        XCTAssertEqual(0, day.run(testInput) as? Int)

        testInput = fix(input: "-1,-2,-3")
        XCTAssertEqual(-6, day.run(testInput) as? Int)
    }

    func testPartTwo() {
        let day = DayOne()

        var testInput = fix(input: "+1, -1")
        XCTAssertEqual(0, day.run(testInput, 2) as? Int)

        testInput = fix(input: "+3, +3, +4, -2, -4")
        XCTAssertEqual(10, day.run(testInput, 2) as? Int)

        testInput = fix(input: "-6, +3, +8, +5, -6")
        XCTAssertEqual(5, day.run(testInput, 2) as? Int)

        testInput = fix(input: "+7, +7, -2, -7, -4")
        XCTAssertEqual(14, day.run(testInput, 2) as? Int)
    }

    func fix(input: String) -> String {
        return input.split(separator: ",")
                    .map(String.init)
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .joined(separator: "\n")
    }
}
