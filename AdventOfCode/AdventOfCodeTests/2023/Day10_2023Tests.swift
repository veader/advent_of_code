//
//  Day10_2023Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/10/23.
//

import XCTest

final class Day10_2023Tests: XCTestCase {

    let sampleGrid1 = """
        .....
        .S-7.
        .|.|.
        .L-J.
        .....
        """

    // should be the same as grid 1 with extra pipes
    let sampleGrid2 = """
        -L|F7
        7S-7|
        L|7||
        -L-J|
        L|-JF
        """

    let sampleGrid3 = """
        ..F7.
        .FJ|.
        SJ.L7
        |F--J
        LJ...
        """

    // should be the same as grid 3 with extra pipes
    let sampleGrid4 = """
        7-F7-
        .FJ|7
        SJLL7
        |F--J
        LJ.LJ
        """

    func testParsingOfGrid() throws {
        let grid = Day10_2023().parse(sampleGrid1)
        grid.printGrid()
        let start = grid.first(where: { $0 == .start })
        XCTAssertEqual(Coordinate(x: 1, y: 1), start)
    }

    func testPipeLengthCounting() throws {
        let day = Day10_2023()

        var grid = day.parse(sampleGrid2)
        var start = try XCTUnwrap(grid.first(where: { $0 == .start }))
        XCTAssertEqual(Coordinate(x: 1, y: 1), start)

        var path = try day.pipeLength(grid: grid)
        XCTAssertEqual(8, path.count)

        grid = day.parse(sampleGrid4)
        start = try XCTUnwrap(grid.first(where: { $0 == .start }))
        XCTAssertEqual(Coordinate(x: 0, y: 2), start)

        path = try day.pipeLength(grid: grid)
        XCTAssertEqual(16, path.count)
    }

    func testPart1() throws {
        var answer = Day10_2023().run(part: 1, sampleGrid2)
        XCTAssertEqual(4, answer as? Int)

        answer = Day10_2023().run(part: 1, sampleGrid4)
        XCTAssertEqual(8, answer as? Int)
    }

    func testPart1Answer() throws {
        var answer = Day10_2023().run(part: 1)
        XCTAssertEqual(6956, answer as? Int)
    }
}
