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

    func testEqualityInstructions() {
        var machine: IntCodeMachine

        // tests if input = 8
        machine = IntCodeMachine(memory: [3,9,8,9,10,9,4,9,99,-1,8])
        machine.inputs = [8]
        machine.run()
        XCTAssertEqual(1, machine.outputs.last!)

        // tests if input = 8
        machine = IntCodeMachine(memory: [3,9,8,9,10,9,4,9,99,-1,8])
        machine.inputs = [9]
        machine.run()
        XCTAssertEqual(0, machine.outputs.last!)

        // tests if input < 8
        machine = IntCodeMachine(memory: [3,9,7,9,10,9,4,9,99,-1,8])
        machine.inputs = [7]
        machine.run()
        XCTAssertEqual(1, machine.outputs.last!)

        // tests if input < 8
        machine = IntCodeMachine(memory: [3,9,7,9,10,9,4,9,99,-1,8])
        machine.inputs = [9]
        machine.run()
        XCTAssertEqual(0, machine.outputs.last!)

        // tests if input = 8
        machine = IntCodeMachine(memory: [3,3,1108,-1,8,3,4,3,99])
        machine.inputs = [8]
        machine.run()
        XCTAssertEqual(1, machine.outputs.last!)

        // tests if input = 8
        machine = IntCodeMachine(memory: [3,3,1108,-1,8,3,4,3,99])
        machine.inputs = [9]
        machine.run()
        XCTAssertEqual(0, machine.outputs.last!)

        // tests if input < 8
        machine = IntCodeMachine(memory: [3,3,1107,-1,8,3,4,3,999])
        machine.inputs = [7]
        machine.run()
        XCTAssertEqual(1, machine.outputs.last!)

        // tests if input < 8
        machine = IntCodeMachine(memory: [3,3,1107,-1,8,3,4,3,999])
        machine.inputs = [9]
        machine.run()
        XCTAssertEqual(0, machine.outputs.last!)
    }

    func testJumpInstructions() {
        var machine: IntCodeMachine

        // is input 0?
        machine = IntCodeMachine(memory: [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9])
        machine.inputs = [0]
        machine.run()
        XCTAssertEqual(0, machine.outputs.last!)

        // is input 0?
        machine = IntCodeMachine(memory: [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9])
        machine.inputs = [2]
        machine.run()
        XCTAssertEqual(1, machine.outputs.last!)

        // is input 0?
        machine = IntCodeMachine(memory: [3,3,1105,-1,9,1101,0,0,12,4,12,99,1])
        machine.inputs = [0]
        machine.run()
        XCTAssertEqual(0, machine.outputs.last!)

        // is input 0?
        machine = IntCodeMachine(memory: [3,3,1105,-1,9,1101,0,0,12,4,12,99,1])
        machine.inputs = [2]
        machine.run()
        XCTAssertEqual(1, machine.outputs.last!)
    }

    func testNewInstructionsLargerExample() {
        let memory = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
                      1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
                      999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]
        var machine: IntCodeMachine

        // < 8 -> 999
        machine = IntCodeMachine(memory: memory)
        machine.inputs = [7]
        machine.run()
        XCTAssertEqual(999, machine.outputs.last!)

        // = 8 -> 1000
        machine = IntCodeMachine(memory: memory)
        machine.inputs = [8]
        machine.run()
        XCTAssertEqual(1000, machine.outputs.last!)

        // = 8 -> 1001
        machine = IntCodeMachine(memory: memory)
        machine.inputs = [9]
        machine.run()
        XCTAssertEqual(1001, machine.outputs.last!)
    }

    func testPartOneAnswer() {
        let day = DayFive()
        let answer = day.run(part: 1) as! Int
        XCTAssertEqual(6069343, answer)
    }

    func testPartTwoAnswer() {
        let day = DayFive()
        let answer = day.run(part: 2) as! Int
        XCTAssertEqual(3188550, answer)
    }
}
