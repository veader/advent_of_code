//
//  DayTwoTests.swift
//  Test
//
//  Created by Shawn Veader on 12/2/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import XCTest

class DayTwoTests: XCTestCase {

    func testStringRepeatExtension() {
        XCTAssertEqual(0, "a".charactersRepeating(times: 2).count)
        XCTAssertEqual(1, "aa".charactersRepeating(times: 2).count)
        XCTAssertEqual(0, "aa".charactersRepeating(times: 3).count)

        XCTAssertFalse("a".hasCharacterRepeating(times: 2))
        XCTAssertTrue("aa".hasCharacterRepeating(times: 2))
        XCTAssertFalse("aa".hasCharacterRepeating(times: 3))

        XCTAssertTrue("bababc".hasCharacterRepeating(times: 2))
        XCTAssertTrue("bababc".hasCharacterRepeating(times: 3))
    }

    func testStringRemainderExtension() {
        XCTAssertEqual("def", "abcdef".substring(after: "abc"))
        XCTAssertEqual("ef", "abcdef".substring(after: "abc", offset: 1))
    }

    func testPartOne() {
        let testInput = """
                        abcdef
                        bababc
                        abbcde
                        abcccd
                        aabcdd
                        abcdee
                        ababab
                        """

        let day = DayTwo()
        XCTAssertEqual(12, day.run(testInput, 1) as? Int)
    }

    func testPartTwo() {
        let testInput = """
                        abcde
                        fghij
                        klmno
                        pqrst
                        fguij
                        axcye
                        wvxyz
                        """

        let day = DayTwo()
        XCTAssertEqual("fgij", day.run(testInput, 2) as? String)
    }
}
