//
//  DayTwenty2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/21/21.
//

import XCTest

class DayTwenty2021Tests: XCTestCase {
    let sampleInput = """
        ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

        #..#.
        #....
        ##..#
        ..#..
        ..###
        """

    func testDayParsing() {
        let day = DayTwenty2021()
        let trenchMap = day.parse(sampleInput)

        XCTAssertEqual(512, trenchMap.algoDecoder.count)
        XCTAssertEqual(10, trenchMap.litPixels.count)
        print(trenchMap.xBounds)
        print(trenchMap.yBounds)
    }

    func testAdjacentPixelMap() {
        let day = DayTwenty2021()
        let trenchMap = day.parse(sampleInput)
        var pixels = trenchMap.pixelMap(for: Coordinate(x: 0, y: 0))
        XCTAssertEqual("....#..#.", pixels)

        pixels = trenchMap.pixelMap(for: Coordinate(x: 1, y: 1))
        XCTAssertEqual("#..#..##.", pixels)

        pixels = trenchMap.pixelMap(for: Coordinate(x: 4, y: 0))
        XCTAssertEqual("...#.....", pixels)

        pixels = trenchMap.pixelMap(for: Coordinate(x: 4, y: 4))
        XCTAssertEqual("...##....", pixels)
    }

    func testPixelDecodeIndex() {
        let day = DayTwenty2021()
        let trenchMap = day.parse(sampleInput)
        var bits = trenchMap.binaryIndex(for: Coordinate(x: 0, y: 0))
        XCTAssertEqual(18, bits)

        bits = trenchMap.binaryIndex(for: Coordinate(x: 1, y: 1))
        XCTAssertEqual(294, bits)

        bits = trenchMap.binaryIndex(for: Coordinate(x: 4, y: 0))
        XCTAssertEqual(32, bits)

        bits = trenchMap.binaryIndex(for: Coordinate(x: 4, y: 4))
        XCTAssertEqual(48, bits)
    }

    func testImageEnhancment() {
        let day = DayTwenty2021()
        let trenchMap = day.parse(sampleInput)
        trenchMap.printImage()
        print("      ")

        trenchMap.enhanceImage()
        trenchMap.printImage()
        print("      ")

        trenchMap.enhanceImage()
        trenchMap.printImage()
        print("      ")
    }
}
