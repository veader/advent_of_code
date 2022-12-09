//
//  DayEight2022Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/8/22.
//

import XCTest

final class DayEight2022Tests: XCTestCase {

    let sampleInput = """
        30373
        25512
        65332
        33549
        35390
        """

    func testParsing() {
        let trees = TreeMap(sampleInput)!
        XCTAssertEqual(3, trees.map[0][0].height)
        XCTAssertEqual(2, trees.map[1][0].height)
        XCTAssertEqual(6, trees.map[2][0].height)
        XCTAssertEqual(0, trees.map[4][4].height)

        XCTAssertEqual(3, trees.tree(at: Coordinate(x: 0, y: 0))?.height)
        XCTAssertEqual(2, trees.tree(at: Coordinate(x: 1, y: 0))?.height)
        XCTAssertEqual(6, trees.tree(at: Coordinate(x: 2, y: 0))?.height)
        XCTAssertEqual(0, trees.tree(at: Coordinate(x: 4, y: 4))?.height)
    }

    func testRowHeightDetection() {
        let trees = TreeMap(sampleInput)!
        trees.detectVisibility()

//        print("---------------------------------")
//        trees.printVisibility()
//        print("---------------------------------")
//        trees.printVisibilityBits()

        XCTAssertTrue(trees.tree(at: Coordinate(x: 1, y: 1))!.canBeSeen)
        XCTAssertTrue(trees.tree(at: Coordinate(x: 1, y: 2))!.canBeSeen)
        XCTAssertFalse(trees.tree(at: Coordinate(x: 1, y: 3))!.canBeSeen)

        XCTAssertTrue(trees.tree(at: Coordinate(x: 2, y: 1))!.canBeSeen)
        XCTAssertFalse(trees.tree(at: Coordinate(x: 2, y: 2))!.canBeSeen)
        XCTAssertTrue(trees.tree(at: Coordinate(x: 2, y: 3))!.canBeSeen)

        XCTAssertFalse(trees.tree(at: Coordinate(x: 3, y: 1))!.canBeSeen)
        XCTAssertTrue(trees.tree(at: Coordinate(x: 3, y: 2))!.canBeSeen)
        XCTAssertFalse(trees.tree(at: Coordinate(x: 3, y: 3))!.canBeSeen)

        XCTAssertEqual(21, trees.visibleCount())
    }

    func testPartOne() {
        let answer = DayEight2022().partOne(input: sampleInput)
        XCTAssertEqual(21, answer as! Int)
    }

    func testScenicScores() {
        let trees = TreeMap(sampleInput)!
        trees.detectVisibility()

        print("---------------------------------")
        trees.printVisibility()
        print("---------------------------------")
        trees.printVisibilityBits()
        print("---------------------------------")
        trees.printScenicScores()
    }
}
