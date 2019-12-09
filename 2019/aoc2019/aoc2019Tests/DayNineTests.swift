//
//  DayNineTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/9/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DayNineTests: XCTestCase {

    func testAdjustRelativeBaseInstruction() {
        var machine = IntCodeMachine(instructions: "109,19")
        XCTAssertEqual(0, machine.relativeBase)
        machine.run()
        XCTAssertEqual(19, machine.relativeBase)

        machine.reset()
        machine.relativeBase = 2000
        XCTAssertEqual(2000, machine.relativeBase)
        machine.run()
        XCTAssertEqual(2019, machine.relativeBase)

        machine = IntCodeMachine(instructions: "109,-19")
        machine.relativeBase = 100
        machine.run()
        XCTAssertEqual(81, machine.relativeBase)
    }

    func testPartOne() {
        var machine: IntCodeMachine

        let copyInstructions = "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
        machine = IntCodeMachine(instructions: copyInstructions)
        machine.run()
        XCTAssertEqual(copyInstructions, machine.outputs.map(String.init).joined(separator: ","))

        machine = IntCodeMachine(instructions: "1102,34915192,34915192,7,4,7,99,0")
        machine.run()
        XCTAssertEqual(1219070632396864, machine.outputs.last)

        machine = IntCodeMachine(instructions: "104,1125899906842624,99")
        machine.run()
        XCTAssertEqual(1125899906842624, machine.outputs.last)
    }

    func testPartOneAnswer() {
        let day = DayNine()
        let answer = day.run(part: 1) as! Int
        XCTAssertEqual(3601950151, answer)
    }

    func testPartTwoAnswer() {
        XCTAssert(true)
        // commented out because of how long it takes to run
//        let day = DayNine()
//        let answer = day.run(part: 2) as! Int
//        XCTAssertEqual(64236, answer)
    }
}
