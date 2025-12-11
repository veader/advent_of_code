//
//  GridLineTests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/10/25.
//

import Testing

struct GridLineTests {

    @Test func testLineComparison() async throws {
        let a = try #require(Coordinate("1,2"))
        let b = try #require(Coordinate("2,3"))

        let sorted = [b,a].sorted()
        #expect(sorted.first == a)
        #expect(sorted.last == b)

        let line = GridLine(start: b, end: a)
        #expect(line.start == a)
        #expect(line.end == b)
    }

    @Test func testHorizontalLinePoints() async throws {
        let a = try #require(Coordinate("1,2"))
        let b = try #require(Coordinate("10,2"))
        let line = GridLine(start: a, end: b)

        let points = line.pointsAlongTheLine
        #expect(points.count == 10)
        #expect(points.map(\.y).unique().count == 1)
    }

    @Test func testVerticalLinePoints() async throws {
        let a = try #require(Coordinate("2,2"))
        let b = try #require(Coordinate("2,12"))
        let line = GridLine(start: a, end: b)

        let points = line.pointsAlongTheLine
        #expect(points.count == 11)
        #expect(points.map(\.x).unique().count == 1)
    }
}
