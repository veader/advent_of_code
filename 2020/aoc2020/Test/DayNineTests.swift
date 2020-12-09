//
//  DayNineTests.swift
//  Test
//
//  Created by Shawn Veader on 12/9/20.
//

import XCTest

class DayNineTests: XCTestCase {

    let testData1 = """
        35
        20
        15
        25
        47
        40
        62
        55
        65
        95
        102
        117
        150
        182
        127
        219
        299
        277
        309
        576
        """

    func testPossibleSumsLogic() {
        let numbers = Array(1...5)
        let cypher = XMASCypher(preamble: 5, data: numbers)
        let sums = cypher.possibleSums(numbers).sorted()
        XCTAssertEqual(Array(3...9), sums)
    }

    func testDataValidationLogic() {
        let data = Array(1...25)
        let cypher = XMASCypher(preamble: 25, data: data)
        XCTAssertTrue(cypher.isValid(26, preable: data))
        XCTAssertTrue(cypher.isValid(49, preable: data))
        XCTAssertFalse(cypher.isValid(100, preable: data))
        XCTAssertFalse(cypher.isValid(50, preable: data))

        let altData = Array(1...19) + Array(21...25) + [45]
        XCTAssertTrue(cypher.isValid(26, preable: altData))
        XCTAssertTrue(cypher.isValid(64, preable: altData))
        XCTAssertTrue(cypher.isValid(66, preable: altData))
        XCTAssertFalse(cypher.isValid(65, preable: altData))
    }

    func testCypherWeaknessFinding() {
        let data = testData1.split(separator: "\n").map(String.init).compactMap(Int.init)
        let cypher = XMASCypher(preamble: 5, data: data)
        let weakness = cypher.findWeakness()
        XCTAssertEqual(127, weakness)
    }
}
