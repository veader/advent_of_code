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

        var testInput = "+1,-2,+3,+1".split(separator: ",").map(String.init).joined(separator: "\n")
        XCTAssertEqual(3, day.run(testInput) as? Int)

        testInput = "+1,+1,+1".split(separator: ",").map(String.init).joined(separator: "\n")
        XCTAssertEqual(3, day.run(testInput) as? Int)

        testInput = "+1,+1,-2".split(separator: ",").map(String.init).joined(separator: "\n")
        XCTAssertEqual(0, day.run(testInput) as? Int)

        testInput = "-1,-2,-3".split(separator: ",").map(String.init).joined(separator: "\n")
        XCTAssertEqual(-6, day.run(testInput) as? Int)
    }

}
