//
//  Day4_2023Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/4/23.
//

import XCTest

final class Day4_2023Tests: XCTestCase {

    let sampleInput = """
        Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
        Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
        Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
        """

    let sampleCard = "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1"

    func testScrathcardParsing() throws {
        let card = try XCTUnwrap(Day4_2023.Scratchcard.parse(sampleCard))

        XCTAssertEqual(card.id, 3)
        XCTAssertEqual(card.winning.count, 5)
        XCTAssertEqual(card.numbers.count, 8)
    }

    func testIntPowerExtension() {
        XCTAssertEqual(1, 2.power(of: 0))
        XCTAssertEqual(2, 2.power(of: 1))
        XCTAssertEqual(4, 2.power(of: 2))

        XCTAssertEqual(0.5, 2.power(of: -1))
    }

    func testPart1() throws {
        let answer = Day4_2023().run(part: 1, sampleInput)
        XCTAssertEqual(13, answer as? Int)
    }

    func testPart1Answer() throws {
        let answer = Day4_2023().run(part: 1)
        XCTAssertEqual(17803, answer as? Int)
    }

    func testPart2() throws {
        let answer = Day4_2023().run(part: 2, sampleInput)
        XCTAssertEqual(30, answer as? Int)
    }

    func testPart2Answer() throws {
        let answer = Day4_2023().run(part: 2)
        XCTAssertEqual(5554894, answer as? Int  )
    }
}
