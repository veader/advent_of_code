//
//  DayTen2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/10/21.
//

import XCTest

class DayTen2021Tests: XCTestCase {

    func testNavSysCmdCorruptionFinding() {
        var cmd = NavSysCmd(command: "[<>({}){}[([])<>]]")
        var result = cmd.isCorrupted()
        XCTAssertFalse(result.0)
        XCTAssertNil(result.1)

        cmd = NavSysCmd(command: "<([]){()}[{}])")
        result = cmd.isCorrupted()
        XCTAssertTrue(result.0)
        XCTAssertNotNil(result.1)

        cmd = NavSysCmd(command: "{([(<{}[<>[]}>{[]{[(<()>")
        result = cmd.isCorrupted()
        XCTAssertTrue(result.0)
        XCTAssertEqual("}", result.1)

        cmd = NavSysCmd(command: "[[<[([]))<([[{}[[()]]]")
        result = cmd.isCorrupted()
        XCTAssertTrue(result.0)
        XCTAssertEqual(")", result.1)

        cmd = NavSysCmd(command: "[{[{({}]{}}([{[{{{}}([]")
        result = cmd.isCorrupted()
        XCTAssertTrue(result.0)
        XCTAssertEqual("]", result.1)

        cmd = NavSysCmd(command: "[<(<(<(<{}))><([]([]()")
        result = cmd.isCorrupted()
        XCTAssertTrue(result.0)
        XCTAssertEqual(")", result.1)

        cmd = NavSysCmd(command: "<{([([[(<>()){}]>(<<{{")
        result = cmd.isCorrupted()
        XCTAssertTrue(result.0)
        XCTAssertEqual(">", result.1)
    }

}
