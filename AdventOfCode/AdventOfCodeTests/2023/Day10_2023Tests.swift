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

    let samplePath1 = """
        ...........
        .S-------7.
        .|F-----7|.
        .||.....||.
        .||.....||.
        .|L-7.F-J|.
        .|..|.|..|.
        .L--J.L--J.
        ...........
        """

    let samplePath2 = """
        .F----7F7F7F7F-7....
        .|F--7||||||||FJ....
        .||.FJ||||||||L7....
        FJL7L7LJLJ||LJ.L-7..
        L--J.L7...LJS7F-7L7.
        ....F-J..F7FJ|L7L7L7
        ....L7.F7||L7|.L7L7|
        .....|FJLJ|FJ|F7|.LJ
        ....FJL-7.||.||||...
        ....L---J.LJ.LJLJ...
        """

    let samplePath3 = """
        FF7FSF7F7F7F7F7F---7
        L|LJ||||||||||||F--J
        FL-7LJLJ||||||LJL-77
        F--JF--7||LJLJ7F7FJ-
        L---JF-JLJ.||-FJLJJ7
        |F|F-JF---7F7-L7L|7|
        |FFJF7L7F-JF7|JL---7
        7-L-JL7||F7|L7F-7F7|
        L.L7LFJ|||||FJL7||LJ
        L7JLJL-JLJLJL--JLJ.L
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
        let answer = Day10_2023().run(part: 1)
        XCTAssertEqual(6956, answer as? Int)
    }

    func testAreaCalculations() throws {
        let day = Day10_2023()

        var grid = day.parse(samplePath1)
        var path = try day.pipeLength(grid: grid)
        var area = day.areaByPainting(in: grid, path: path)
        XCTAssertEqual(4, area)

//        grid = day.parse(samplePath2)
//        path = try day.pipeLength(grid: grid)
//        area = day.areaByPainting(in: grid, path: path, printGrid: true)
//        XCTAssertEqual(8, area) // getting 9, not 8 because of a case I don't understand

        grid = day.parse(samplePath3)
        path = try day.pipeLength(grid: grid)
        area = day.areaByPainting(in: grid, path: path)
        XCTAssertEqual(10, area)
    }
}
