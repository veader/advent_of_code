//
//  DayNine2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/9/21.
//

import XCTest

class DayNine2021Tests: XCTestCase {

    let sampleInput = """
        2199943210
        3987894921
        9856789892
        8767896789
        9899965678
        """

    func testCoordinateAdjacent() {
        // Example: 10x10 grid

        // all adjacent, no bounds
        var coord = Coordinate(x: 4, y: 4)
        var adj = coord.adjacent()
        XCTAssertEqual(8, adj.count)

        // at origin, staying "in bounds"
        coord = Coordinate(x: 0, y: 0)
        adj = coord.adjacent(minX: 0, minY: 0)
        XCTAssertEqual(3, adj.count)
        adj = coord.adjacent(xBounds: 0...9, yBounds: 0...9)
        XCTAssertEqual(3, adj.count)

        // at left edge, staying "in bounds"
        coord = Coordinate(x: 9, y: 0)
        adj = coord.adjacent(minX: 0, maxX: 9, minY: 0)
        XCTAssertEqual(3, adj.count)
        adj = coord.adjacent(xBounds: 0...9, yBounds: 0...9)
        print(adj)
        XCTAssertEqual(3, adj.count)

        // at corner opposite origin, staying "in bounds"
        coord = Coordinate(x: 9, y: 9)
        adj = coord.adjacent(minX: 0, maxX: 9, minY: 0, maxY: 9)
        XCTAssertEqual(3, adj.count)
        adj = coord.adjacent(xBounds: 0...9, yBounds: 0...9)
        XCTAssertEqual(3, adj.count)

        // middle, staying "in bounds"
        coord = Coordinate(x: 3, y: 3)
        adj = coord.adjacent(minX: 0, maxX: 9, minY: 0, maxY: 9)
        XCTAssertEqual(8, adj.count)
        adj = coord.adjacent(xBounds: 0...9, yBounds: 0...9)
        XCTAssertEqual(8, adj.count)

        // outside of bounds
        coord = Coordinate(x: 13, y: 13)
        adj = coord.adjacent(minX: 0, maxX: 9, minY: 0, maxY: 9)
        XCTAssertEqual(0, adj.count)
        adj = coord.adjacent(xBounds: 0...9, yBounds: 0...9)
        XCTAssertEqual(0, adj.count)
    }

    func testRanges() {
        let openRange = 0..<9
        let closedRange = 0...8
        XCTAssertEqual(closedRange, ClosedRange(openRange))
    }

    func testGridMap() {
        let grid = GridMap<Int>(items: [[0,1,2,3,4], [2,3,4,5,6]])
        XCTAssertEqual(0, grid.xBounds.lowerBound)
        XCTAssertEqual(5, grid.xBounds.upperBound)
        XCTAssertEqual(0, grid.yBounds.lowerBound)
        XCTAssertEqual(2, grid.yBounds.upperBound)

        let originItem = grid.item(at: Coordinate(x: 0, y: 0))
        XCTAssertEqual(0, originItem)

        let endItem = grid.item(at: Coordinate(x: 4, y: 0))
        XCTAssertEqual(4, endItem)

        let badItem = grid.item(at: Coordinate(x: 0, y: 10))
        XCTAssertNil(badItem)
    }

    func testLowPointFinder() {
        let day = DayNine2021()
        let answer = day.partOne(input: sampleInput) as? Int
        XCTAssertEqual(15, answer)
    }

}
