//
//  DayThreeTests.swift
//  Test
//
//  Created by Shawn Veader on 12/3/20.
//

import XCTest

class DayThreeTests: XCTestCase {

    let testMap = """
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
    """

    func testForestMapParsing() {
        let forest = Forest(testMap)
        XCTAssertNotNil(forest)
        XCTAssertEqual(11, forest?.mapWidth)
        XCTAssertEqual(11, forest?.mapHeight)
        forest?.printMap()
    }

    func testForestMapSubscripting() {
        let forest = Forest(testMap)!
        XCTAssertEqual(Forest.Space.empty, forest.at(x: 3, y: 1))
        XCTAssertEqual(Forest.Space.tree, forest.at(x: 6, y: 2))
        XCTAssertEqual(Forest.Space.tree, forest.at(x: 17, y: 2))
        XCTAssertNil(forest.at(x: 6, y: 200))
    }

    func testForestTravel() {
        let slope = Forest.Slope(rise: 1, run: 3)
        let forest = Forest(testMap)!

        let result = forest.travel(slope: slope)
        XCTAssertEqual(11, result.path.count)
        XCTAssertEqual(11, result.spaces.count)
    }

    func testForestTravelImpacts() {
        let slope = Forest.Slope(rise: 1, run: 3)
        let forest = Forest(testMap)!

        let impacts = forest.impacts(traveling: slope)
        XCTAssertEqual(7, impacts)
    }

    func testPartTwo() {
        let slopes = [
            Forest.Slope(rise: 1, run: 1),
            Forest.Slope(rise: 1, run: 3),
            Forest.Slope(rise: 1, run: 5),
            Forest.Slope(rise: 1, run: 7),
            Forest.Slope(rise: 2, run: 1),
        ]

        let forest = Forest(testMap)!
        let impacts = slopes.map { forest.impacts(traveling: $0) }
        let total = impacts.reduce(1, { $0 * $1 })

        XCTAssertEqual(336, total)
    }
}
