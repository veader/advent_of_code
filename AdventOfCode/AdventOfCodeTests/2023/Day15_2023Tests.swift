//
//  Day15_2023Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/15/23.
//

import XCTest

final class Day15_2023Tests: XCTestCase {

    let sampleInput = """
        rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
        """

    func testSimpleHashMethod() throws {
        let answer = "HASH".simpleHash
        XCTAssertEqual(answer, 52)
    }

    func testPart1() throws {
        let answer = Day15_2023().run(part: 1, sampleInput)
        XCTAssertEqual(1320, answer as? Int)
    }

    func testPart1Answer() throws {
        let answer = Day15_2023().run(part: 1)
        XCTAssertEqual(507769, answer as? Int)
    }
}
