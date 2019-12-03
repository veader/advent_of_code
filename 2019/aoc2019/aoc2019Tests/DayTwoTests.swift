//
//  DayTwoTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/2/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DayTwoTests: XCTestCase {

    func testPartOne() {
        var machine = IntCodeMachine(memory: [1,0,0,0,99])
        machine.run()
        XCTAssertEqual([2,0,0,0,99], machine.memory)

        machine = IntCodeMachine(memory: [2,3,0,3,99])
        machine.run()
        XCTAssertEqual([2,3,0,6,99], machine.memory)

        machine = IntCodeMachine(memory: [2,4,4,5,99,0])
        machine.run()
        XCTAssertEqual([2,4,4,5,99,9801], machine.memory)

        machine = IntCodeMachine(memory: [1,1,1,4,99,5,6,0,99])
        machine.run()
        XCTAssertEqual([30,1,1,4,2,5,6,0,99], machine.memory)
    }

    func testPartOneAnswer() {
        let day = DayTwo()
        let answer = day.run(part: 1) as! Int
        XCTAssertEqual(9706670, answer)
    }

    func testPartTwoAnswer() {
        let day = DayTwo()
        let answer = day.run(part: 2) as! Int
        XCTAssertEqual(2552, answer)
    }
}
