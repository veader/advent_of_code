//
//  DayEightTests.swift
//  Test
//
//  Created by Shawn Veader on 12/8/20.
//

import XCTest

class DayEightTests: XCTestCase {

    let sampleLoopCode = """
        nop +0
        acc +1
        jmp +4
        acc +3
        jmp -3
        acc -99
        acc +1
        jmp -4
        acc +6
        """

    func testBootInstructionParsing() {
        var inst: BootInstruction?

        // bad instructions
        inst = BootInstruction(rawValue: "")
        XCTAssertNil(inst)
        inst = BootInstruction(rawValue: "jmp")
        XCTAssertNil(inst)

        // noop
        inst = BootInstruction(rawValue: "nop +0")
        XCTAssertNotNil(inst)
        if case BootInstruction.noop(let value) = inst! {
            XCTAssertEqual(0, value)
        } else {
            XCTFail("Noop instruction not read properly")
        }

        inst = BootInstruction(rawValue: "nop -2")
        XCTAssertNotNil(inst)
        if case BootInstruction.noop(let value) = inst! {
            XCTAssertEqual(-2, value)
        } else {
            XCTFail("Noop instruction not read properly")
        }

        // accumulate
        inst = BootInstruction(rawValue: "acc +3")
        XCTAssertNotNil(inst)
        if case BootInstruction.accumulate(let value) = inst! {
            XCTAssertEqual(3, value)
        } else {
            XCTFail("Accumulate instruction not read properly")
        }

        inst = BootInstruction(rawValue: "acc -99")
        XCTAssertNotNil(inst)
        if case BootInstruction.accumulate(let value) = inst! {
            XCTAssertEqual(-99, value)
        } else {
            XCTFail("Accumulate instruction not read properly")
        }


        // jump
        inst = BootInstruction(rawValue: "jmp +4")
        XCTAssertNotNil(inst)
        if case BootInstruction.jump(let value) = inst! {
            XCTAssertEqual(4, value)
        } else {
            XCTFail("Jump instruction not read properly")
        }

        inst = BootInstruction(rawValue: "jmp -4")
        XCTAssertNotNil(inst)
        if case BootInstruction.jump(let value) = inst! {
            XCTAssertEqual(-4, value)
        } else {
            XCTFail("Jump instruction not read properly")
        }
    }

    func testBootCodeLoopFinding() {
        let bootCode = BootCode(sampleLoopCode.split(separator: "\n").map(String.init))
        bootCode.detectLoop()
        XCTAssertEqual(5, bootCode.accumulator)
    }

}
