//
//  DayTenTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/10/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DayTenTests: XCTestCase {

    func testSpaceMapParsing() {
        var map: SpaceMap

        map = SpaceMap(input: testMap1)
        XCTAssertEqual(5, map.width)
        XCTAssertEqual(5, map.height)
        XCTAssert(map.asteroids.keys.contains(Coordinate(x: 1, y: 0)))
        XCTAssert(map.asteroids.keys.contains(Coordinate(x: 2, y: 2)))
        XCTAssertFalse(map.asteroids.keys.contains(Coordinate(x: 0, y: 0)))

        map = SpaceMap(input: testMap2)
        XCTAssertEqual(10, map.width)
        XCTAssertEqual(10, map.height)
    }

    func testSpaceMapPrinting() {
        var map: SpaceMap
        var printedMap: String

        map = SpaceMap(input: testMap1)
        printedMap = map.printMap()
        XCTAssertEqual(testMap1+"\n", printedMap)
        // map.calculateVisibilityCounts()
        // map.printMap(showCounts: true)

        map = SpaceMap(input: testMap2)
        printedMap = map.printMap()
        XCTAssertEqual(testMap2+"\n", printedMap)
        // map.calculateVisibilityCounts()
        // map.printMap(showCounts: true)
    }

    func testCoordinateSlopes() {
        let origin = Coordinate.origin
        var slope1: Coordinate.SlopeType
        var slope2: Coordinate.SlopeType

        slope1 = origin.slope(to: Coordinate(x: 3, y: 1))
        XCTAssertEqual(.normal(slope: 1/3, direction: 1), slope1)
        slope2 = origin.slope(to: Coordinate(x: 6, y: 2))
        XCTAssertEqual(slope1, slope2)

        slope1 = origin.slope(to: Coordinate(x: 3, y: 2))
        XCTAssertEqual(.normal(slope: 2/3, direction: 1), slope1)
        slope2 = origin.slope(to: Coordinate(x: 6, y: 4))
        XCTAssertEqual(slope1, slope2)

        // vertical (up)
        slope1 = origin.slope(to: Coordinate(x: 0, y: 2))
        XCTAssertEqual(.vertical(direction: 1), slope1)
        slope2 = origin.slope(to: Coordinate(x: 0, y: 4))
        XCTAssertEqual(slope1, slope2)

        // vertical (down)
        slope1 = origin.slope(to: Coordinate(x: 0, y: -2))
        XCTAssertEqual(.vertical(direction: -1), slope1)
        slope2 = origin.slope(to: Coordinate(x: 0, y: -4))
        XCTAssertEqual(slope1, slope2)

        // horizontal (right)
        slope1 = origin.slope(to: Coordinate(x: 2, y: 0))
        XCTAssertEqual(.horizontal(direction: 1), slope1)
        slope2 = origin.slope(to: Coordinate(x: 4, y: 0))
        XCTAssertEqual(slope1, slope2)

        // horizontal (left)
        slope1 = origin.slope(to: Coordinate(x: -2, y: 0))
        XCTAssertEqual(.horizontal(direction: -1), slope1)
        slope2 = origin.slope(to: Coordinate(x: -4, y: 0))
        XCTAssertEqual(slope1, slope2)
    }

    func testPartOne() {
        var map: SpaceMap
        var location: Coordinate?

        map = SpaceMap(input: testMap1)
        location = map.maxVisibilityLocation()
        XCTAssertEqual(Coordinate(x: 3, y: 4), location)
        XCTAssertEqual(8, map.visibility(at: location!))

        map = SpaceMap(input: testMap2)
        location = map.maxVisibilityLocation()
        XCTAssertEqual(Coordinate(x: 5, y: 8), location)
        XCTAssertEqual(33, map.visibility(at: location!))

        map = SpaceMap(input: testMap3)
        location = map.maxVisibilityLocation()
        XCTAssertEqual(Coordinate(x: 1, y: 2), location)
        XCTAssertEqual(35, map.visibility(at: location!))

        map = SpaceMap(input: testMap4)
        location = map.maxVisibilityLocation()
        XCTAssertEqual(Coordinate(x: 6, y: 3), location)
        XCTAssertEqual(41, map.visibility(at: location!))

        map = SpaceMap(input: testMap5)
        location = map.maxVisibilityLocation()
        XCTAssertEqual(Coordinate(x: 11, y: 13), location)
        XCTAssertEqual(210, map.visibility(at: location!))
    }

    func testArrayUnique() {
        let arr = [1,1,1,2,3,3,3,4,5,6,6,7]
        let uniq = arr.unique()
        print(uniq)
        XCTAssertEqual(7, uniq.count)
    }

    func testSpaceLaserDirectionSteps() {
        let location = Coordinate(x: 4, y: 4)
        let map = SpaceMap(width: 10, height: 10, asteroids: AsteroidMap())
        map.addStation(at: location)
        let laser = map.laserStation

        XCTAssertEqual(0, laser?.directionIndex)

        // top & bottom = 10, sides = 8 => 36
        XCTAssertEqual(36, laser?.directionSteps.count)

//        print(laser.directionIndex)
//        print(laser.direction)
//        print(laser.directionSteps)
    }

    func testLaserDestruction() {
        let stationLocation = Coordinate(x: 8, y: 3)
        let map = SpaceMap(input: testMap6)
        map.addStation(at: stationLocation)
        map.printMap()

        let count = map.asteroids.count

        let destroyed = map.fireTheFreakingLaser()
        // map.printMap()
        XCTAssertEqual(destroyed.count, count)
    }

    func testPartOneAnswer() {
        let day = DayTen()
        let answer = day.run(part: 1) as! Int
        XCTAssertEqual(309, answer)
    }

    func testPartTwoAnswer() {
        XCTAssert(true)
//        let day = DayTen()
//        let answer = day.run(part: 2) as! Int
//        XCTAssertEqual(64236, answer)
    }

    let testMap1 =  """
                    .#..#
                    .....
                    #####
                    ....#
                    ...##
                    """

    // Best is 5,8 with 33 other asteroids detected
    let testMap2 =  """
                    ......#.#.
                    #..#.#....
                    ..#######.
                    .#.#.###..
                    .#..#.....
                    ..#....#.#
                    #..#....#.
                    .##.#..###
                    ##...#..#.
                    .#....####
                    """

    // Best is 1,2 with 35 other asteroids detected
    let testMap3 =  """
                    #.#...#.#.
                    .###....#.
                    .#....#...
                    ##.#.#.#.#
                    ....#.#.#.
                    .##..###.#
                    ..#...##..
                    ..##....##
                    ......#...
                    .####.###.
                    """

    // Best is 6,3 with 41 other asteroids detected
    let testMap4 =  """
                    .#..#..###
                    ####.###.#
                    ....###.#.
                    ..###.##.#
                    ##.##.#.#.
                    ....###..#
                    ..#.#..#.#
                    #..#.#.###
                    .##...##.#
                    .....#.#..
                    """

    // Best is 11,13 with 210 other asteroids detected
    let testMap5 =  """
                    .#..##.###...#######
                    ##.############..##.
                    .#.######.########.#
                    .###.#######.####.#.
                    #####.##.#.##.###.##
                    ..#####..#.#########
                    ####################
                    #.####....###.#.#.##
                    ##.#################
                    #####.##.###..####..
                    ..######..##.#######
                    ####.##.####...##..#
                    .#####..#.######.###
                    ##...#.##########...
                    #.##########.#######
                    .####.#.###.###.#.##
                    ....##.##.###..#####
                    .#.#.###########.###
                    #.#.#.#####.####.###
                    ###.##.####.##.#..##
                    """

    // 8,3 is the location of the station
    let testMap6 =  """
                    .#....#####...#..
                    ##...##.#####..##
                    ##...#...#.#####.
                    ..#.....#...###..
                    ..#.#.....#....##
                    """
}
