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
        let system = SolarSystem(sampleInput)
        let galaxiesBefore = system.findGalaxies()
        XCTAssertEqual(10, system.spaceMap.xBounds.count)
        XCTAssertEqual(10, system.spaceMap.yBounds.count)

        system.simpleExpand()
        let galaxiesAfter = system.findGalaxies()
        XCTAssertEqual(13, system.spaceMap.xBounds.count)
        XCTAssertEqual(12, system.spaceMap.yBounds.count)

        XCTAssertNotEqual(galaxiesAfter, galaxiesBefore)
        XCTAssertEqual(galaxiesBefore.count, galaxiesAfter.count)
    }

    func testFindGalaxies() {
        let system = SolarSystem(sampleInput)
        system.simpleExpand()
        let galaxies = system.findGalaxies()
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
        let system = SolarSystem(sampleInput)
        system.simpleExpand()
        let distances = system.calculateDistances()
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

    func testSolarSystemExpand() {
        let system = SolarSystem(sampleInput)
        system.expand()

        let simpleSystem = SolarSystem(sampleInput)
        simpleSystem.simpleExpand()

        XCTAssertEqual(system.galaxies, simpleSystem.galaxies)
    }

    func testSolarSystemLargerExpansion() {
        var system = SolarSystem(sampleInput)
        system.expand(by: 10)
        var distances = system.calculateDistances()
        XCTAssertEqual(1030, distances.reduce(0, +))

        system = SolarSystem(sampleInput)
        system.expand(by: 100)
        distances = system.calculateDistances()
        XCTAssertEqual(8410, distances.reduce(0, +))
    }

    func testPart2Answer() {
        let answer = Day11_2023().run(part: 2)
        XCTAssertEqual(692506533832, answer as? Int)
    }

}
