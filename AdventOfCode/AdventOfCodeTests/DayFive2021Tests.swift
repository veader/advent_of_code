//
//  DayFive2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/5/21.
//

import XCTest

class DayFive2021Tests: XCTestCase {
    let sampleInput = """
    0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2
    """

    func testLineParing() {
        var line = Line.parse("565,190 -> 756,381")
        XCTAssertNotNil(line)
        XCTAssertEqual(565, line!.start.x)
        XCTAssertEqual(190, line!.start.y)
        XCTAssertEqual(756, line!.end.x)
        XCTAssertEqual(381, line!.end.y)

        line = Line.parse("39,2 -> 391,4478")
        XCTAssertNotNil(line)
        XCTAssertEqual(39, line!.start.x)
        XCTAssertEqual(2, line!.start.y)
        XCTAssertEqual(391, line!.end.x)
        XCTAssertEqual(4478, line!.end.y)
    }

    func testLineIsHorizontal() {
        var line = Line.parse("0,1 -> 10,1")
        XCTAssertTrue(line!.isHorizontal)
        XCTAssertFalse(line!.isVertical)
        XCTAssertFalse(line!.isDiagonal)

        line = Line.parse("0,1 -> 10,2")
        XCTAssertFalse(line!.isHorizontal)
    }

    func testLineIsVertical() {
        var line = Line.parse("0,1 -> 0,10")
        XCTAssertTrue(line!.isVertical)
        XCTAssertFalse(line!.isHorizontal)
        XCTAssertFalse(line!.isDiagonal)

        line = Line.parse("0,1 -> 10,2")
        XCTAssertFalse(line!.isVertical)
    }

    func testLineIsDiagonal() {
        let line = Line.parse("0,0 -> 2,2")
        XCTAssertFalse(line!.isVertical)
        XCTAssertFalse(line!.isHorizontal)
        XCTAssertTrue(line!.isDiagonal)
    }

    func testLineDirection() {
        var line = Line.parse("0,0 -> 0,1")
        XCTAssertEqual(.down, line!.direction)

        line = Line.parse("0,2 -> 0,0")
        XCTAssertEqual(.up, line!.direction)

        line = Line.parse("0,0 -> 2,0")
        XCTAssertEqual(.right, line!.direction)

        line = Line.parse("4,0 -> 2,0")
        XCTAssertEqual(.left, line!.direction)

        line = Line.parse("0,0 -> 2,2")
        XCTAssertEqual(.downRight, line!.direction)

        line = Line.parse("2,2 -> 0,4")
        XCTAssertEqual(.downLeft, line!.direction)

        line = Line.parse("2,2 -> 4,0")
        XCTAssertEqual(.upRight, line!.direction)

        line = Line.parse("2,2 -> 0,0")
        XCTAssertEqual(.upLeft, line!.direction)
    }

    func testLinePoints() {
        var line = Line.parse("0,1 -> 0,10")
        var points = line!.points()
        XCTAssertEqual(10, points.count)

        line = Line.parse("0,1 -> 8,1")
        points = line!.points()
        XCTAssertEqual(9, points.count)

        line = Line.parse("0,0 -> 4,4")
        points = line!.points()
        XCTAssertEqual(5, points.count)
    }

    func testOceanFloor() {
        let day = DayFive2021()
        let lines = day.parse(sampleInput)
        let floor = OceanFloor(lines: lines)
        XCTAssertEqual(10, floor.ventLines.count)
        XCTAssertFalse(floor.floorMap.isEmpty)
    }

    func testOceanFloorMap() {
        let day = DayFive2021()
        let lines = day.parse(sampleInput)
        let floor = OceanFloor(lines: lines)
        XCTAssertNil(floor.floorMap[Coordinate(x: 0, y: 0)])
        XCTAssertEqual(1, floor.floorMap[Coordinate(x: 7, y: 0)])
        XCTAssertEqual(2, floor.floorMap[Coordinate(x: 0, y: 9)])
    }

    func testOceanFloorOverlap() {
        let day = DayFive2021()
        let lines = day.parse(sampleInput)
        let floor = OceanFloor(lines: lines)
        XCTAssertEqual(5, floor.overlapPoints().count)
    }

    func testOceanFloorOverlapWithDiagonals() {
        let day = DayFive2021()
        let lines = day.parse(sampleInput)
        let floor = OceanFloor(lines: lines, ignoreDiagonals: false)
        XCTAssertEqual(12, floor.overlapPoints().count)
    }
}
