//
//  DayFourteenTests.swift
//  Test
//
//  Created by Shawn Veader on 12/14/20.
//

import XCTest

class DayFourteenTests: XCTestCase {

    func testIntMasking() {
        let mask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"
        var intValue = 11
        var finalValue = intValue.applying(mask: mask)
        XCTAssertEqual(73, finalValue)

        intValue = 101
        finalValue = intValue.applying(mask: mask)
        XCTAssertEqual(101, finalValue)

        intValue = 0
        finalValue = intValue.applying(mask: mask)
        XCTAssertEqual(64, finalValue)
    }

    func testDockingProgramInit() {
        let dockingProg = DockingProgram()
        dockingProg.initialize(testInput)
        print(dockingProg.memory)
        XCTAssertEqual(165, dockingProg.memorySum)
    }

    let testInput = """
        mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
        mem[8] = 11
        mem[7] = 101
        mem[8] = 0
        """
}
