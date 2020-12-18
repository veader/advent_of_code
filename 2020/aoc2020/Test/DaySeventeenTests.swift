//
//  DaySeventeenTests.swift
//  Test
//
//  Created by Shawn Veader on 12/17/20.
//

import XCTest

class DaySeventeenTests: XCTestCase {

    func testPowerSourceParsing() {
        let source = PowerSource(testInput)
        XCTAssertEqual(5, source.activeCubes)
        // print(source)
    }

    func testPowerSourceFirstCycle() {
        let source = PowerSource(testInput)
        source.cycle()
        XCTAssertEqual(11, source.activeCubes)
        // print(source)
    }

    func testPowerSourceSecondCycle() {
        let source = PowerSource(testInput)
        source.run(cycles: 2, shouldPrint: false)
        XCTAssertEqual(21, source.activeCubes)
    }

    func testPowerSourceInitialSixCycles() {
        let source = PowerSource(testInput)
        source.run(cycles: 6, shouldPrint: false)
        XCTAssertEqual(112, source.activeCubes)
    }

    let testInput = """
        .#.
        ..#
        ###
        """
}
