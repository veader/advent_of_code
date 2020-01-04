//
//  DayTwentyFourTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 1/4/20.
//  Copyright © 2020 Shawn Veader. All rights reserved.
//

import XCTest

class DayTwentyFourTests: XCTestCase {

    func testGridParsing() {
        let day = DayTwentyFour()
        let grid = day.parse(testInput0)

        // print(grid)
        XCTAssertEqual(grid.description, testInput0 + "\n")

        XCTAssert(grid.bugs.contains(Coordinate(x: 4, y: 0)))
        XCTAssert(grid.bugs.contains(Coordinate(x: 0, y: 1)))

        XCTAssertFalse(grid.bugs.contains(Coordinate(x: 0, y: 0)))
        XCTAssertFalse(grid.bugs.contains(Coordinate(x: 1, y: 1)))
    }

    func testGridIncrement() {
        let day = DayTwentyFour()
        let grid = day.parse(testInput0)

        var newGrid: BugGrid

        newGrid = grid.increment()
        XCTAssertEqual(newGrid.description, testInput1 + "\n")

        newGrid = newGrid.increment()
        XCTAssertEqual(newGrid.description, testInput2 + "\n")

        newGrid = newGrid.increment()
        XCTAssertEqual(newGrid.description, testInput3 + "\n")

        newGrid = newGrid.increment()
        XCTAssertEqual(newGrid.description, testInput4 + "\n")
    }

    func testGridBiodiversityRating() {
        let day = DayTwentyFour()
        let grid = day.parse(testInputDupe)
        XCTAssertEqual(2129920, grid.biodiversityRating())
    }

    func testPartOne() {
        let day = DayTwentyFour()
        let answer: Int = day.partOne(input: testInput0) as! Int
        XCTAssertEqual(2129920, answer)
    }

    func testFindDupeGrid() {
        let day = DayTwentyFour()
        let grid = day.parse(testInput0)
        let dupeGrid = day.findDuplicateGrid(starter: grid)
        XCTAssertEqual(dupeGrid.description, testInputDupe + "\n")
    }

    let testInput0 = """
                     ....#
                     #..#.
                     #..##
                     ..#..
                     #....
                     """
    let testInput1 = """
                     #..#.
                     ####.
                     ###.#
                     ##.##
                     .##..
                     """
    let testInput2 = """
                     #####
                     ....#
                     ....#
                     ...#.
                     #.###
                     """
    let testInput3 = """
                     #....
                     ####.
                     ...##
                     #.##.
                     .##.#
                     """
    let testInput4 = """
                     ####.
                     ....#
                     ##..#
                     .....
                     ##...
                     """

    let testInputDupe = """
                        .....
                        .....
                        .....
                        #....
                        .#...
                        """
}
