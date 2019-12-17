//
//  DaySixteenTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/16/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DaySixteenTests: XCTestCase {

    func testPhase() {
        // first phase
        var output = FFT.phase1(input: [1,2,3,4,5,6,7,8])
        XCTAssertEqual(4, output[0])
        XCTAssertEqual(8, output[1])
        XCTAssertEqual(2, output[2])
        XCTAssertEqual(2, output[3])
        XCTAssertEqual(6, output[4])
        XCTAssertEqual(1, output[5])
        XCTAssertEqual(5, output[6])
        XCTAssertEqual(8, output[7])

        // second phase
        output = FFT.phase1(input: output)
        XCTAssertEqual(3, output[0])
        XCTAssertEqual(4, output[1])
        XCTAssertEqual(0, output[2])
        XCTAssertEqual(4, output[3])
        XCTAssertEqual(0, output[4])
        XCTAssertEqual(4, output[5])
        XCTAssertEqual(3, output[6])
        XCTAssertEqual(8, output[7])

        // third phase
        output = FFT.phase1(input: output)
        XCTAssertEqual(0, output[0])
        XCTAssertEqual(3, output[1])
        XCTAssertEqual(4, output[2])
        XCTAssertEqual(1, output[3])
        XCTAssertEqual(5, output[4])
        XCTAssertEqual(5, output[5])
        XCTAssertEqual(1, output[6])
        XCTAssertEqual(8, output[7])

        // fourth phase
        output = FFT.phase1(input: output)
        XCTAssertEqual(0, output[0])
        XCTAssertEqual(1, output[1])
        XCTAssertEqual(0, output[2])
        XCTAssertEqual(2, output[3])
        XCTAssertEqual(9, output[4])
        XCTAssertEqual(4, output[5])
        XCTAssertEqual(9, output[6])
        XCTAssertEqual(8, output[7])
    }

    func testFFTProcess() {
        let output = FFT.process1(input: [1,2,3,4,5,6,7,8], phases: 4)
        XCTAssertEqual(0, output[0])
        XCTAssertEqual(1, output[1])
        XCTAssertEqual(0, output[2])
        XCTAssertEqual(2, output[3])
        XCTAssertEqual(9, output[4])
        XCTAssertEqual(4, output[5])
        XCTAssertEqual(9, output[6])
        XCTAssertEqual(8, output[7])
    }

    func testPartOne() {
        let day = DaySixteen()

        var input: [Int]
        var output: [Int]
        var outputStr: String

        input = day.parse("80871224585914546619083218645595")
        output = FFT.process1(input: input, phases: 100)
        outputStr = output.prefix(8).map(String.init).joined()
        XCTAssertEqual("24176176", outputStr)

        input = day.parse("19617804207202209144916044189917")
        output = FFT.process1(input: input, phases: 100)
        outputStr = output.prefix(8).map(String.init).joined()
        XCTAssertEqual("73745418", outputStr)

        input = day.parse("69317163492948606335995924319873")
        output = FFT.process1(input: input, phases: 100)
        outputStr = output.prefix(8).map(String.init).joined()
        XCTAssertEqual("52432133", outputStr)
    }

    func testPhase2Idea() {
        let day = DaySixteen()

        var input: [Int]
        var output: [Int]
        var outputStr: String

        input = day.parse("80871224585914546619083218645595")
        output = FFT.process(input: &input, phases: 100)
        outputStr = output.prefix(8).map(String.init).joined()
        XCTAssertEqual("24176176", outputStr)

//        input = day.parse("19617804207202209144916044189917")
//        output = FFT.process(input: &input, phases: 100)
//        outputStr = output.prefix(8).map(String.init).joined()
//        XCTAssertEqual("73745418", outputStr)
//
//        input = day.parse("69317163492948606335995924319873")
//        output = FFT.process(input: &input, phases: 100)
//        outputStr = output.prefix(8).map(String.init).joined()
//        XCTAssertEqual("52432133", outputStr)
    }

    func testPhaseOffsetIdea() {
        var input = [1,2,3,4,5,6,7,8]
        FFT.phase(input: &input, offset: 1)
        print(input)
        XCTAssertEqual(8, input[1])
        print(input)
        FFT.phase(input: &input, offset: 1)
        XCTAssertEqual(4, input[1])
        print(input)
    }

    func testPartTwo() {
        XCTAssert(true)
//        let day = DaySixteen()
//        var output: String
//
//        output = day.partTwo(input: "03036732577212944063491565474664") as! String
//        XCTAssertEqual("84462026", output)
//
//        output = day.partTwo(input: "02935109699940807407585447034323") as! String
//        XCTAssertEqual("78725270", output)
//
//        output = day.partTwo(input: "03081770884921959731165446850517") as! String
//        XCTAssertEqual("53553731", output)
    }

}
