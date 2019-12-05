//
//  DayFiveTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/5/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DayFiveTests: XCTestCase {

    func testOpCodeInstructionCreation() {
        var answer: IntCodeMachine.Instruction
        var param: IntCodeMachine.Instruction.OpCodeParam

        // basic instruction with no param data
        answer = IntCodeMachine.Instruction(input: 1)
        XCTAssertEqual(.add, answer.opcode)

        param = answer.parameters[0]
        if case .position(offset: let offset) = param {
            XCTAssertEqual(1, offset)
        } else {
            XCTFail("Param 0")
        }

        param = answer.parameters[1]
        if case .position(offset: let offset) = param {
            XCTAssertEqual(2, offset)
        } else {
            XCTFail("Param 1")
        }

        param = answer.parameters[2]
        if case .position(offset: let offset) = param {
            XCTAssertEqual(3, offset)
        } else {
            XCTFail("Param 2")
        }

        // -----------------------------
        // full multiply with param data
        answer = IntCodeMachine.Instruction(input: 1002)
        XCTAssertEqual(.multiply, answer.opcode)

        param = answer.parameters[0] // should be position
        if case .position(offset: let offset) = param {
            XCTAssertEqual(1, offset)
        } else {
            XCTFail("Param 0")
        }

        param = answer.parameters[1] // should be immediate
        if case .immediate(offset: let offset) = param {
            XCTAssertEqual(2, offset)
        } else {
            XCTFail("Param 1 not immediate")
        }

        param = answer.parameters[2] // should default to position
        if case .position(offset: let offset) = param {
            XCTAssertEqual(3, offset)
        } else {
            XCTFail("Param 2")
        }
    }

    func testInputInstruction() {
        // should read from inputs and store at 0 in memory
        var machine = IntCodeMachine(memory: [3,0])
        machine.inputs = [5,6]

        let stepResult = machine.runStep()
        XCTAssertEqual(.input, stepResult.opcode)

        XCTAssertEqual(5, machine.memory(at: 0))
        XCTAssertEqual(1, machine.inputs.count)
    }

    func testPartOneAnswer() {
        let day = DayFive()
        let answer = day.run(part: 1) as! Int
        XCTAssertEqual(6069343, answer)
    }

//    func testPartTwoAnswer() {
//        let day = DayFour()
//        let answer = day.run(part: 2) as! Int
//        XCTAssertEqual(1111, answer)
//    }
}
