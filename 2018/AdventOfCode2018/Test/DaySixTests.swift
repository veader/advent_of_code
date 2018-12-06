//
//  DaySixTests.swift
//  Test
//
//  Created by Shawn Veader on 12/6/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import XCTest

class DaySixTests: XCTestCase {

    let input = """
                    1, 1
                    1, 6
                    8, 3
                    3, 4
                    5, 5
                    8, 9
                    """

    func testParsingOfCoordinates() {
        let day = DaySix()
        let coordinates = day.process(input: input)
        XCTAssertEqual(6, coordinates.count)
        XCTAssertEqual(Coordinate(x:1, y:1), coordinates.first)
        XCTAssertEqual(Coordinate(x:8, y:9), coordinates.last)
    }

    func testGridPrinting() {
        let output = """
                     ..........
                     .X........
                     ..........
                     ........X.
                     ...X......
                     .....X....
                     .X........
                     ..........
                     ..........
                     ........X.
                     ..........

                     """

        let day = DaySix()
        let coordinates = day.process(input: input)
        let grid = DaySix.Grid(coordinates: coordinates, overage: 1)
        let response = grid.printCoordinateGrid()
        XCTAssertEqual(output, response)
    }

    func testGridSumPrinting() {
        let day = DaySix()
        let coordinates = day.process(input: input)
        var grid = DaySix.Grid(coordinates: coordinates, overage: 1)
        grid.calculateDistanceSums()
        let response = grid.printSumGrid(lessThan: 32)
        print(response)
    }

    func testGridDistancePrinting() {
        let output = """
                     00000.2222
                     0X000.2222
                     0003342222
                     00333422X2
                     ..3X344222
                     11.34X4422
                     1X1.4444..
                     111.444555
                     111.445555
                     111.5555X5
                     111.555555

                     """

        let day = DaySix()
        let coordinates = day.process(input: input)
        var grid = DaySix.Grid(coordinates: coordinates, overage: 1)
        grid.calculateDistances()
        let response = grid.printDistanceGrid()
        XCTAssertEqual(output, response)
    }

    func testGridAreaCalculations() {
        let day = DaySix()
        let coordinates = day.process(input: input)
        var grid = DaySix.Grid(coordinates: coordinates, overage: 1)
        grid.calculateDistances()

        XCTAssertEqual(9, grid.area(of: Coordinate(x: 3, y: 4)))
        XCTAssertEqual(17, grid.area(of: Coordinate(x: 5, y: 5)))
    }

    func testGridSumAreaCalculations() {
        let day = DaySix()
        let coordinates = day.process(input: input)
        var grid = DaySix.Grid(coordinates: coordinates, overage: 1)
        grid.calculateDistanceSums()
        XCTAssertEqual(16, grid.area(lessThan: 32))
    }

    func testRunPartOne() {
        let day = DaySix()
        if let answer = day.run(input, 1) as? Int {
            XCTAssertEqual(17, answer)
        } else {
            XCTFail("Part One Failed")
        }
    }
}
