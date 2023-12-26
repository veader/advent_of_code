//
//  Day17_2023Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/20/23.
//

import XCTest

final class Day17_2023Tests: XCTestCase {

    let sampleInput = """
        2413432311323
        3215453535623
        3255245654254
        3446585845452
        4546657867536
        1438598798454
        4457876987766
        3637877979653
        4654967986887
        4564679986453
        1224686865563
        2546548887735
        4322674655533
        """

    func testBasicParsing() {
        let grid = Day17_2023().parse(sampleInput)
        XCTAssertEqual(13, grid.xBounds.count)
        XCTAssertEqual(13, grid.yBounds.count)
        XCTAssertEqual(2, grid.itemAt(x: 0, y: 0))
        XCTAssertEqual(4, grid.itemAt(x: 1, y: 0))
        XCTAssertEqual(3, grid.itemAt(x: 0, y: 1))
    }

    func xtestCrucibleRouteFinding() async throws {
        let data = Day17_2023().parse(sampleInput)
        let route = CrucibleRoute(data: data)
        let destination = try XCTUnwrap(route.calculateRoute(trackPath: true))
        print(destination.location)
        print(destination.cost)
        print(destination.minDistance)
        print(destination.shortedPath)
        XCTAssertEqual(102, destination.minDistance)
    }

//    func xtestCrucibleRoutePossibleValues() {
//        let data = Day17_2023().parse(sampleInput)
//        let route = CrucibleRoute(data: data)
//        let possible = route.possibleRoutes(from: .origin, moving: .east, along: [])
//        print(possible)
//        XCTAssertEqual(2, possible.count)
//    }
}
