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
        let fft = FFT()

        // first phase
        var output = fft.phase(input: [1,2,3,4,5,6,7,8])
        XCTAssertEqual(4, output[0])
        XCTAssertEqual(8, output[1])
        XCTAssertEqual(2, output[2])
        XCTAssertEqual(2, output[3])
        XCTAssertEqual(6, output[4])
        XCTAssertEqual(1, output[5])
        XCTAssertEqual(5, output[6])
        XCTAssertEqual(8, output[7])

        // second phase
        output = fft.phase(input: output)
        XCTAssertEqual(3, output[0])
        XCTAssertEqual(4, output[1])
        XCTAssertEqual(0, output[2])
        XCTAssertEqual(4, output[3])
        XCTAssertEqual(0, output[4])
        XCTAssertEqual(4, output[5])
        XCTAssertEqual(3, output[6])
        XCTAssertEqual(8, output[7])

        // third phase
        output = fft.phase(input: output)
        XCTAssertEqual(0, output[0])
        XCTAssertEqual(3, output[1])
        XCTAssertEqual(4, output[2])
        XCTAssertEqual(1, output[3])
        XCTAssertEqual(5, output[4])
        XCTAssertEqual(5, output[5])
        XCTAssertEqual(1, output[6])
        XCTAssertEqual(8, output[7])

        // fourth phase
        output = fft.phase(input: output)
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
        let output = FFT().process(input: [1,2,3,4,5,6,7,8], phases: 4)
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
        let fft = FFT()

        var input: [Int]
        var output: [Int]
        var outputStr: String

        input = day.parse("80871224585914546619083218645595")
        output = fft.process(input: input, phases: 100)
        outputStr = output.prefix(8).map(String.init).joined()
        XCTAssertEqual("24176176", outputStr)

        input = day.parse("19617804207202209144916044189917")
        output = fft.process(input: input, phases: 100)
        outputStr = output.prefix(8).map(String.init).joined()
        XCTAssertEqual("73745418", outputStr)

        input = day.parse("69317163492948606335995924319873")
        output = fft.process(input: input, phases: 100)
        outputStr = output.prefix(8).map(String.init).joined()
        XCTAssertEqual("52432133", outputStr)
    }

}
