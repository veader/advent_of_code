//
//  ClosedRangeTests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/6/23.
//

import XCTest

final class ClosedRangeTests: XCTestCase {

    func testIntersectNoOverlap() {
        let answer = (0...10).intersections(with: 11...15)
        XCTAssertNil(answer)
    }

    func testIntersectSame() {
        let answer = (0...10).intersections(with: 0...10)
        XCTAssertNil(answer?.before)
        XCTAssertNil(answer?.after)
        XCTAssertEqual(answer?.overlap, 0...10)
    }

    func testIntersectBefore() {
        let answer = (10...20).intersections(with: 0...13)
        XCTAssertEqual(0...9, answer?.before)
        XCTAssertEqual(10...13, answer?.overlap)
        XCTAssertEqual(14...20, answer?.after)
    }

    func testIntersectAfter() {
        let answer = (10...20).intersections(with: 15...25)
        XCTAssertEqual(10...14, answer?.before)
        XCTAssertEqual(15...20, answer?.overlap)
        XCTAssertEqual(21...25, answer?.after)
    }

    func testIntersectMiddle() {
        let answer = (0...20).intersections(with: 5...10)
        XCTAssertEqual(0...4, answer?.before)
        XCTAssertEqual(5...10, answer?.overlap)
        XCTAssertEqual(11...20, answer?.after)
    }

    func testIntersectMiddleContained() {
        let answer = (5...10).intersections(with: 0...20)
        XCTAssertEqual(0...4, answer?.before)
        XCTAssertEqual(5...10, answer?.overlap)
        XCTAssertEqual(11...20, answer?.after)
    }

    func testIntersectMatchingStart() {
        let answer = (0...20).intersections(with: 0...5)
        XCTAssertNil(answer?.before)
        XCTAssertEqual(0...5, answer?.overlap)
        XCTAssertEqual(6...20, answer?.after)
    }

    func testIntersectMatchingEnd() {
        let answer = (0...20).intersections(with: 15...20)
        XCTAssertEqual(0...14, answer?.before)
        XCTAssertEqual(15...20, answer?.overlap)
        XCTAssertNil(answer?.after)
    }

}
