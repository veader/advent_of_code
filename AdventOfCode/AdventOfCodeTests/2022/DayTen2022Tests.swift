//
//  DayTen2022Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/10/22.
//

import XCTest

final class DayTen2022Tests: XCTestCase {

    let sampleInput = """
        noop
        addx 3
        addx -5
        """

    let largerSampleInput = """
        addx 15
        addx -11
        addx 6
        addx -3
        addx 5
        addx -1
        addx -8
        addx 13
        addx 4
        noop
        addx -1
        addx 5
        addx -1
        addx 5
        addx -1
        addx 5
        addx -1
        addx 5
        addx -1
        addx -35
        addx 1
        addx 24
        addx -19
        addx 1
        addx 16
        addx -11
        noop
        noop
        addx 21
        addx -15
        noop
        noop
        addx -3
        addx 9
        addx 1
        addx -3
        addx 8
        addx 1
        addx 5
        noop
        noop
        noop
        noop
        noop
        addx -36
        noop
        addx 1
        addx 7
        noop
        noop
        noop
        addx 2
        addx 6
        noop
        noop
        noop
        noop
        noop
        addx 1
        noop
        noop
        addx 7
        addx 1
        noop
        addx -13
        addx 13
        addx 7
        noop
        addx 1
        addx -33
        noop
        noop
        noop
        addx 2
        noop
        noop
        noop
        addx 8
        noop
        addx -1
        addx 2
        addx 1
        noop
        addx 17
        addx -9
        addx 1
        addx 1
        addx -3
        addx 11
        noop
        noop
        addx 1
        noop
        addx 1
        noop
        noop
        addx -13
        addx -19
        addx 1
        addx 3
        addx 26
        addx -30
        addx 12
        addx -1
        addx 3
        addx 1
        noop
        noop
        noop
        addx -9
        addx 18
        addx 1
        addx 2
        noop
        noop
        addx 9
        noop
        noop
        noop
        addx -1
        addx 2
        addx -37
        addx 1
        addx 3
        noop
        addx 15
        addx -21
        addx 22
        addx -6
        addx 1
        noop
        addx 2
        addx 1
        noop
        addx -10
        noop
        noop
        addx 20
        addx 1
        addx 2
        addx 2
        addx -6
        addx -11
        noop
        noop
        noop
        """


    func testInstructionParsing() {
        let cpu = SimpleCPU(sampleInput)
        XCTAssertEqual(3, cpu.instructions.count)
        XCTAssertEqual(.noop, cpu.instructions[0])
        XCTAssertEqual(.addx(3), cpu.instructions[1])
        XCTAssertEqual(.addx(-5), cpu.instructions[2])
    }

    func testLargerInstructionParsing() {
        let cpu = SimpleCPU(largerSampleInput)
        XCTAssertEqual(146, cpu.instructions.count)
    }

    func testSimpleRun() {
        let cpu = SimpleCPU(sampleInput)
        XCTAssertEqual(3, cpu.instructions.count)

        cpu.run()
        XCTAssertEqual(6, cpu.cycles.count)
        print(cpu.cycles)

        XCTAssertEqual(1, cpu.cycles[0])
        XCTAssertEqual(1, cpu.cycles[1])  // read: no-op
        XCTAssertEqual(1, cpu.cycles[2])  // read: addx 3
        XCTAssertEqual(4, cpu.cycles[3])  // execute: addx 3
        XCTAssertEqual(4, cpu.cycles[4])  // read: addx -5
        XCTAssertEqual(-1, cpu.cycles[5]) // execute: addx -5

        XCTAssertEqual(1, cpu.value(during: 3))
        XCTAssertEqual(4, cpu.value(after: 3))
    }

    func testLargerRun() {
        let cpu = SimpleCPU(largerSampleInput)
        XCTAssertEqual(146, cpu.instructions.count)

        cpu.run()
        XCTAssertEqual(241, cpu.cycles.count)
        print(cpu.cycles)

        XCTAssertEqual(21, cpu.value(during: 20))
        XCTAssertEqual(19, cpu.value(during: 60))
        XCTAssertEqual(18, cpu.value(during: 100))
        XCTAssertEqual(21, cpu.value(during: 140))
        XCTAssertEqual(16, cpu.value(during: 180))
        XCTAssertEqual(18, cpu.value(during: 220))
    }

    func testPartOne() {
        let answer = DayTen2022().partOne(input: largerSampleInput)
        XCTAssertEqual(13140, answer as! Int)
    }

    func testOutputRow() {
        let cpu = SimpleCPU(largerSampleInput)
        cpu.run()

        let firstRow = "##..##..##..##..##..##..##..##..##..##.."
        var displayedRow = cpu.outputRow(start: 1, width: 40)
        XCTAssertEqual(firstRow, displayedRow)

        let secondRow = "###...###...###...###...###...###...###."
        displayedRow = cpu.outputRow(start: 41, width: 40)
        XCTAssertEqual(secondRow, displayedRow)

        let thirdRow = "####....####....####....####....####...."
        displayedRow = cpu.outputRow(start: 81, width: 40)
        XCTAssertEqual(thirdRow, displayedRow)

        let fourthRow = "#####.....#####.....#####.....#####....."
        displayedRow = cpu.outputRow(start: 121, width: 40)
        XCTAssertEqual(fourthRow, displayedRow)

        let fifthRow = "######......######......######......####"
        displayedRow = cpu.outputRow(start: 161, width: 40)
        XCTAssertEqual(fifthRow, displayedRow)

        let sixthRow = "#######.......#######.......#######....."
        displayedRow = cpu.outputRow(start: 201, width: 40)
        XCTAssertEqual(sixthRow, displayedRow)
    }

    func testDisplayOutput() {
        let cpu = SimpleCPU(largerSampleInput)
        cpu.run()
        cpu.draw()
    }
}
