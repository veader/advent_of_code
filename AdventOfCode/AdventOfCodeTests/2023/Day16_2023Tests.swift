//
//  Day16_2023Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/18/23.
//

import XCTest

final class Day16_2023Tests: XCTestCase {
    let sampleInput = """
        .|...\\....
        |.-.\\.....
        .....|-...
        ........|.
        ..........
        .........\\
        ..../.\\\\..
        .-.-/..|..
        .|....-|.\\
        ..//.|....
        """ // silly backslash chars causing problems...

    func testParsing() {
        let lm = LightMap(sampleInput)
        XCTAssertEqual(10, lm.data.xBounds.count)
        XCTAssertEqual(10, lm.data.yBounds.count)
//        lm.data.printGrid()
    }

    func testLightMapTracing() async {
        let lm = LightMap(sampleInput)
        XCTAssertEqual(0, lm.energizedPoints.count)
        let result = await lm.traceLight()
        XCTAssertEqual(46, result)
    }

    func testPart1() async {
        let answer = await Day16_2023().run(part: 1, sampleInput)
        XCTAssertEqual(46, answer as? Int)
    }

    func testPart1Answer() async {
        let answer = await Day16_2023().run(part: 1)
        XCTAssertEqual(7498, answer as? Int)
    }

    func testFindBestTrace() async {
        let lm = LightMap(sampleInput)
        let result = await lm.findBestTrace()
        XCTAssertEqual(51, result)
    }

    func testPart2() async {
        let answer = await Day16_2023().run(part: 2, sampleInput)
        XCTAssertEqual(51, answer as? Int)
    }
}
