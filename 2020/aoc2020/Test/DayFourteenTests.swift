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

    func testIntMaskingPartTwo() {
        var intValue: Int
        var maskedValue: String

        intValue = 42
        maskedValue = intValue.masked(with: "000000000000000000000000000000X1001X")
        XCTAssertEqual("000000000000000000000000000000X1101X", maskedValue)

        intValue = 26
        maskedValue = intValue.masked(with: "00000000000000000000000000000000X0XX")
        XCTAssertEqual("00000000000000000000000000000001X0XX", maskedValue)
    }

    func testAddressMaskingPermutations() {
        var mask: String
        var addresses: [Int]

        let dockingProg = DockingProgram()

        mask = "000000000000000000000000000000X1101X"
        // print(mask)
        addresses = dockingProg.memoryDecoder(addrMask: mask)
        XCTAssertEqual(4, addresses.count)
        XCTAssertTrue(addresses.contains(26))
        XCTAssertTrue(addresses.contains(27))
        XCTAssertTrue(addresses.contains(58))
        XCTAssertTrue(addresses.contains(59))

        mask = "00000000000000000000000000000001X0XX"
        // print(mask)
        addresses = dockingProg.memoryDecoder(addrMask: mask)
        XCTAssertEqual(8, addresses.count)
        XCTAssertTrue(addresses.contains(16))
        XCTAssertTrue(addresses.contains(17))
        XCTAssertTrue(addresses.contains(18))
        XCTAssertTrue(addresses.contains(19))
        XCTAssertTrue(addresses.contains(24))
        XCTAssertTrue(addresses.contains(25))
        XCTAssertTrue(addresses.contains(26))
        XCTAssertTrue(addresses.contains(27))
    }

    func testDockingProgramInit() {
        let dockingProg = DockingProgram()
        dockingProg.initialize(testInput)
        // print(dockingProg.memory)
        XCTAssertEqual(165, dockingProg.memorySum)
    }

    func testDockingProgramInitV2() {
        let dockingProg = DockingProgram()
        dockingProg.initialize(testInput2, version: 2)
        // print(dockingProg.memory)
        XCTAssertEqual(208, dockingProg.memorySum)
    }

    let testInput = """
        mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
        mem[8] = 11
        mem[7] = 101
        mem[8] = 0
        """

    let testInput2 = """
        mask = 000000000000000000000000000000X1001X
        mem[42] = 100
        mask = 00000000000000000000000000000000X0XX
        mem[26] = 1
        """
}
