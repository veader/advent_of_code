//
//  GridMapTests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/11/23.
//

import XCTest

final class GridMapTests: XCTestCase {

    func testAddingRowBottom() {
        let values = (0..<10).map { y in
            Array(repeating: "\(y)", count: 6)
        }

        let grid = GridMap(items: values)
        XCTAssertEqual(6, grid.xBounds.count)
        XCTAssertEqual(10, grid.yBounds.count)
        XCTAssertEqual("0", grid.itemAt(x: 0, y: 0))
        XCTAssertEqual("1", grid.itemAt(x: 0, y: 1))

        grid.insertRow(at: 0, value: "-")
        XCTAssertEqual(6, grid.xBounds.count)
        XCTAssertEqual(11, grid.yBounds.count)
        XCTAssertEqual("-", grid.itemAt(x: 0, y: 0))
        XCTAssertEqual("0", grid.itemAt(x: 0, y: 1))
    }

    func testAddingRowMiddle() {
        let values = (0..<10).map { y in
            Array(repeating: "\(y)", count: 6)
        }

        let grid = GridMap(items: values)
        XCTAssertEqual(6, grid.xBounds.count)
        XCTAssertEqual(10, grid.yBounds.count)
        XCTAssertEqual("4", grid.itemAt(x: 0, y: 4))
        XCTAssertEqual("5", grid.itemAt(x: 0, y: 5))

        grid.insertRow(at: 5, value: "-")
        XCTAssertEqual(6, grid.xBounds.count)
        XCTAssertEqual(11, grid.yBounds.count)
        XCTAssertEqual("4", grid.itemAt(x: 0, y: 4))
        XCTAssertEqual("-", grid.itemAt(x: 0, y: 5))
        XCTAssertEqual("5", grid.itemAt(x: 0, y: 6))
    }

    func testAddingRowTop() {
        let values = (0..<10).map { y in
            Array(repeating: "\(y)", count: 6)
        }

        let grid = GridMap(items: values)
        XCTAssertEqual(6, grid.xBounds.count)
        XCTAssertEqual(10, grid.yBounds.count)
        XCTAssertEqual("8", grid.itemAt(x: 0, y: 8))
        XCTAssertEqual("9", grid.itemAt(x: 0, y: 9))

        grid.insertRow(at: 10, value: "-")
        XCTAssertEqual(6, grid.xBounds.count)
        XCTAssertEqual(11, grid.yBounds.count)
        XCTAssertEqual("9", grid.itemAt(x: 0, y: 9))
        XCTAssertEqual("-", grid.itemAt(x: 0, y: 10))
    }

    func testAddingColumnFront() {
        let values = (0..<10).map { y in
            (0..<6).map { "\($0)" }
        }

        let grid = GridMap(items: values)
        XCTAssertEqual(6, grid.xBounds.count)
        XCTAssertEqual(10, grid.yBounds.count)
        XCTAssertEqual("0", grid.itemAt(x: 0, y: 0))
        XCTAssertEqual("1", grid.itemAt(x: 1, y: 0))

        grid.insertColumn(at: 0, value: "|")
        XCTAssertEqual(7, grid.xBounds.count)
        XCTAssertEqual(10, grid.yBounds.count)
        XCTAssertEqual("|", grid.itemAt(x: 0, y: 0))
        XCTAssertEqual("0", grid.itemAt(x: 1, y: 0))
        XCTAssertEqual("1", grid.itemAt(x: 2, y: 0))
    }

    func testAddingColumnMiddle() {
        let values = (0..<10).map { y in
            (0..<6).map { "\($0)" }
        }

        let grid = GridMap(items: values)
        XCTAssertEqual(6, grid.xBounds.count)
        XCTAssertEqual(10, grid.yBounds.count)
        XCTAssertEqual("3", grid.itemAt(x: 3, y: 0))
        XCTAssertEqual("4", grid.itemAt(x: 4, y: 0))

        grid.insertColumn(at: 4, value: "|")
        XCTAssertEqual(7, grid.xBounds.count)
        XCTAssertEqual(10, grid.yBounds.count)
        XCTAssertEqual("3", grid.itemAt(x: 3, y: 0))
        XCTAssertEqual("|", grid.itemAt(x: 4, y: 0))
        XCTAssertEqual("4", grid.itemAt(x: 5, y: 0))
    }

    func testAddingColumnBack() {
        let values = (0..<10).map { y in
            (0..<6).map { "\($0)" }
        }

        let grid = GridMap(items: values)
        XCTAssertEqual(6, grid.xBounds.count)
        XCTAssertEqual(10, grid.yBounds.count)
        XCTAssertEqual("4", grid.itemAt(x: 4, y: 0))
        XCTAssertEqual("5", grid.itemAt(x: 5, y: 0))

        grid.insertColumn(at: 6, value: "|")
        XCTAssertEqual(7, grid.xBounds.count)
        XCTAssertEqual(10, grid.yBounds.count)
        XCTAssertEqual("5", grid.itemAt(x: 5, y: 0))
        XCTAssertEqual("|", grid.itemAt(x: 6, y: 0))
    }
}
