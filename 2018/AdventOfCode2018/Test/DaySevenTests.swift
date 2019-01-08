//
//  DaySevenTests.swift
//  Test
//
//  Created by Shawn Veader on 12/7/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import XCTest

class DaySevenTests: XCTestCase {

    let input = """
                Step C must be finished before step A can begin.
                Step C must be finished before step F can begin.
                Step A must be finished before step B can begin.
                Step A must be finished before step D can begin.
                Step B must be finished before step E can begin.
                Step D must be finished before step E can begin.
                Step F must be finished before step E can begin.
                """

    func testLineParsing() {
        let day = DaySeven()

        let input1 = "Step C must be finished before step A can begin."
        let answer = day.parse(line: input1)
        XCTAssertEqual("C", answer?.prereq)
        XCTAssertEqual("A", answer?.nextStep)

        XCTAssertNil(day.parse(line: "Foo bar baz"))
    }

    func testParsing() {
        let day = DaySeven()

        let instructions = day.parse(input: input)
        // instructions.values.forEach { print($0) }

        let a = instructions["A"]
        XCTAssertEqual(["C"], a?.prereqs)
        XCTAssertEqual(["B", "D"], a?.nextSteps)
    }

    func testBeginningFinding() {
        let day = DaySeven()
        let instructions = day.parse(input: input)
        XCTAssertEqual(["C"], day.findBeginnings(instructions: instructions))
    }

    func testEndFinding() {
        let day = DaySeven()
        let instructions = day.parse(input: input)
        XCTAssertEqual("E", day.findEnding(instructions: instructions))
    }

    func testRunOne() {
        let day = DaySeven()
        let steps = day.run(input, 1) as? String
        XCTAssertEqual("CABDFE", steps)
    }

    func testRunTwo() {
        let day = DaySeven()
        let steps = day.run(input, 2) as? Int
        XCTAssertEqual(253, steps)
    }

    func testWorkLogic() {
        let day = DaySeven()
        let instructions = day.parse(input: input)

        let answer = day.work(instructions: instructions, workers: 2, offset: 0)
        XCTAssertEqual(15, answer)
    }

    func testLetters() {
        let a = 65
        let z = 65+25
        XCTAssertEqual("A", Character(UnicodeScalar(a)!))
        XCTAssertEqual("Z", Character(UnicodeScalar(z)!))
    }
}
