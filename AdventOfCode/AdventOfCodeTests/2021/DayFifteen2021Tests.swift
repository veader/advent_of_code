//
//  DayFifteen2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/15/21.
//

import XCTest

class DayFifteen2021Tests: XCTestCase {

    let sampleInput = """
        1163751742
        1381373672
        2136511328
        3694931569
        7463417111
        1319128137
        1359912421
        3125421639
        1293138521
        2311944581
        """

    func testDijkstrasAlgo() {
        let day = DayFifteen2021()
        let grid = day.parse(sampleInput)
        let final = day.dijkstrasAlgo(grid: grid)
        XCTAssertNotNil(final)
        XCTAssertEqual(Coordinate(x: 9, y: 9), final!.location)
        XCTAssertEqual(40, final!.minDistance)

        print("=================")
        print(final!)
    }

}
