//
//  Day11_2023Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/11/23.
//

import XCTest

final class Day11_2023Tests: XCTestCase {

    let sampleInput = """
        ...#......
        .......#..
        #.........
        ..........
        ......#...
        .#........
        .........#
        ..........
        .......#..
        #...#.....
        """

    func testFindBlankRowsAndColumns() {
        let day = Day11_2023()
        let grid = day.parse(sampleInput)
        let galaxiesBefore = day.findGalaxies(in: grid).sorted(by: { $0.y < $1.y && $0.x < $1.x })
        XCTAssertEqual(10, grid.xBounds.count)
        XCTAssertEqual(10, grid.yBounds.count)

        day.expand(grid)
        let galaxiesAfter = day.findGalaxies(in: grid).sorted(by: { $0.y < $1.y && $0.x < $1.x })
        XCTAssertEqual(13, grid.xBounds.count)
        XCTAssertEqual(12, grid.yBounds.count)

        XCTAssertNotEqual(galaxiesAfter, galaxiesBefore)
        XCTAssertEqual(galaxiesBefore.count, galaxiesAfter.count)
    }

    func testFindGalaxies() {
        let day = Day11_2023()
        let grid = day.parse(sampleInput)
        day.expand(grid)
        let galaxies = day.findGalaxies(in: grid)//.sorted(by: { $0.y < $1.y && $0.x < $1.x })
        XCTAssertEqual(9, galaxies.count)
    }

    func testDistances() {
        let one = Coordinate(x: 4, y: 0)
        let three = Coordinate(x: 0, y: 2)
        let five = Coordinate(x: 1, y: 6)
        let six = Coordinate(x: 7, y: 12)
        let seven = Coordinate(x: 9, y: 10)
        let eight = Coordinate(x: 0, y: 11)
        let nine = Coordinate(x: 5, y: 11)
        XCTAssertEqual(9, five.distance(to: nine))
        XCTAssertEqual(15, one.distance(to: seven))
        XCTAssertEqual(17, three.distance(to: six))
        XCTAssertEqual(5, eight.distance(to: nine))
    }

    func testCalculatingDistances() {
        let day = Day11_2023()
        let grid = day.parse(sampleInput)
        day.expand(grid)
        let distances = day.calculateDistances(in: grid)
        XCTAssertEqual(36, distances.count) // the number of pairs
    }

    func testPart1() {
        let answer = Day11_2023().run(part: 1, sampleInput)
        XCTAssertEqual(374, answer as? Int)
    }

    func testPart1Answer() {
        let answer = Day11_2023().run(part: 1)
        XCTAssertEqual(9918828, answer as? Int)
    }
}
