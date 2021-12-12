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
        XCTAssertFalse(cmd.isCorrupted)
        XCTAssertFalse(cmd.isOpen)
        XCTAssertNil(cmd.parseResult.corruptValue)

        cmd = NavSysCmd(command: "<([]){()}[{}])")
        XCTAssertTrue(cmd.isCorrupted)
        XCTAssertNotNil(cmd.parseResult.corruptValue)

        cmd = NavSysCmd(command: "{([(<{}[<>[]}>{[]{[(<()>")
        XCTAssertTrue(cmd.isCorrupted)
        XCTAssertEqual("}", cmd.parseResult.corruptValue)

        cmd = NavSysCmd(command: "[[<[([]))<([[{}[[()]]]")
        XCTAssertTrue(cmd.isCorrupted)
        XCTAssertEqual(")", cmd.parseResult.corruptValue)

        cmd = NavSysCmd(command: "[{[{({}]{}}([{[{{{}}([]")
        XCTAssertTrue(cmd.isCorrupted)
        XCTAssertEqual("]", cmd.parseResult.corruptValue)

        cmd = NavSysCmd(command: "[<(<(<(<{}))><([]([]()")
        XCTAssertTrue(cmd.isCorrupted)
        XCTAssertEqual(")", cmd.parseResult.corruptValue)

        cmd = NavSysCmd(command: "<{([([[(<>()){}]>(<<{{")
        XCTAssertTrue(cmd.isCorrupted)
        XCTAssertEqual(">", cmd.parseResult.corruptValue)
    }

    func testOpenCommandFixes() {
        var cmd = NavSysCmd(command: "[<>({}){}[([])<>]]")
        XCTAssertFalse(cmd.isOpen)
        XCTAssertEqual("", cmd.closingString())

        cmd = NavSysCmd(command: "[({(<(())[]>[[{[]{<()<>>")
        XCTAssertTrue(cmd.isOpen)
        XCTAssertEqual("}}]])})]", cmd.closingString())

        cmd = NavSysCmd(command: "[(()[<>])]({[<{<<[]>>(")
        XCTAssertTrue(cmd.isOpen)
        XCTAssertEqual(")}>]})", cmd.closingString())

        cmd = NavSysCmd(command: "(((({<>}<{<{<>}{[]{[]{}")
        XCTAssertTrue(cmd.isOpen)
        XCTAssertEqual("}}>}>))))", cmd.closingString())

        cmd = NavSysCmd(command: "{<[[]]>}<{[{[{[]{()[[[]")
        XCTAssertTrue(cmd.isOpen)
        XCTAssertEqual("]]}}]}]}>", cmd.closingString())

        cmd = NavSysCmd(command: "<{([{{}}[<[[[<>{}]]]>[]]")
        XCTAssertTrue(cmd.isOpen)
        XCTAssertEqual("])}>", cmd.closingString())
    }

    func testPartTwoOpenCommandScore() {
        let day = DayTen2021()
        var cmd = NavSysCmd(command: "<{([{{}}[<[[[<>{}]]]>[]]")
        XCTAssertEqual(294, day.score(openCommand: cmd))

        cmd = NavSysCmd(command: "[({(<(())[]>[[{[]{<()<>>")
        XCTAssertEqual(288957, day.score(openCommand: cmd))

        cmd = NavSysCmd(command: "[(()[<>])]({[<{<<[]>>(")
        XCTAssertEqual(5566, day.score(openCommand: cmd))

        cmd = NavSysCmd(command: "(((({<>}<{<{<>}{[]{[]{}")
        XCTAssertEqual(1480781, day.score(openCommand: cmd))
    }

}
