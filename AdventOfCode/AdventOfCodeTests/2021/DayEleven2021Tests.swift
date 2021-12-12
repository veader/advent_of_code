//
//  DayEleven2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/12/21.
//

import XCTest

class DayEleven2021Tests: XCTestCase {

    let simpleSampleInput = """
        11111
        19991
        19191
        19991
        11111
        """

    let sampleInput = """
        5483143223
        2745854711
        5264556173
        6141336146
        6357385478
        4167524645
        2176841721
        6882881134
        4846848554
        5283751526
        """

    func testSimpleSingleStep() {
        let day = DayEleven2021()
        let grid = day.parse(simpleSampleInput)
        let flashes = day.countFlashes(grid: grid, stepCount: 1)
        XCTAssertEqual(9, flashes)
        XCTAssertEqual([3,4,5,4,3], grid.row(y: 0))
        XCTAssertEqual([4,0,0,0,4], grid.row(y: 1))
        XCTAssertEqual([5,0,0,0,5], grid.row(y: 2))
        XCTAssertEqual([4,0,0,0,4], grid.row(y: 3))
        XCTAssertEqual([3,4,5,4,3], grid.row(y: 4))
    }

    func testSimpleTwoSteps() {
        let day = DayEleven2021()
        let grid = day.parse(simpleSampleInput)
        let flashes = day.countFlashes(grid: grid, stepCount: 2)
        XCTAssertEqual(9, flashes)
        XCTAssertEqual([4,5,6,5,4], grid.row(y: 0))
        XCTAssertEqual([5,1,1,1,5], grid.row(y: 1))
        XCTAssertEqual([6,1,1,1,6], grid.row(y: 2))
        XCTAssertEqual([5,1,1,1,5], grid.row(y: 3))
        XCTAssertEqual([4,5,6,5,4], grid.row(y: 4))
    }

    func testFlashCountingTwoSteps() {
        let day = DayEleven2021()
        let grid = day.parse(sampleInput)
        let flashes = day.countFlashes(grid: grid, stepCount: 2)
        XCTAssertEqual(35, flashes)
        XCTAssertEqual([8,8,0,7,4,7,6,5,5,5], grid.row(y: 0))
        XCTAssertEqual([5,0,8,9,0,8,7,0,5,4], grid.row(y: 1))
        XCTAssertEqual([8,5,9,7,8,8,9,6,0,8], grid.row(y: 2))
    }

    func testFlashCountingTenSteps() {
        let day = DayEleven2021()
        let grid = day.parse(sampleInput)
        let flashes = day.countFlashes(grid: grid, stepCount: 10)
        XCTAssertEqual(204, flashes)
        XCTAssertEqual([0,4,8,1,1,1,2,9,7,6], grid.row(y: 0))
        XCTAssertEqual([0,0,3,1,1,1,2,0,0,9], grid.row(y: 1))
        XCTAssertEqual([0,0,4,1,1,1,2,5,0,4], grid.row(y: 2))
    }

    func testFlashCountingHundredSteps() {
        let day = DayEleven2021()
        let grid = day.parse(sampleInput)
        let flashes = day.countFlashes(grid: grid, stepCount: 100)
        XCTAssertEqual(1656, flashes)
    }
}
