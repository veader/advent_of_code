//
//  DayElevenTests.swift
//  Test
//
//  Created by Shawn Veader on 12/11/20.
//

import XCTest

class DayElevenTests: XCTestCase {

    func testSeatMapParsing() {
        let theMap = SeatMap(testInput)
        XCTAssertNotNil(theMap)
        XCTAssertEqual(10, theMap?.rows)
        XCTAssertEqual(10, theMap?.columns)
        XCTAssertEqual(SeatMap.Space.floor, theMap?.spaceAt(x: 1, y: 0))
        XCTAssertEqual(SeatMap.Space.emptySeat, theMap?.spaceAt(x: 0, y: 0))
        // print(theMap!)
    }

    func testSeatMapSpaceLocation() {
        let theMap = SeatMap(testInput)!
        XCTAssertNil(theMap.spaceAt(x: -1, y: 0))
        XCTAssertNil(theMap.spaceAt(x: 11, y: 0))
        XCTAssertNil(theMap.spaceAt(x: 0, y: -1))
        XCTAssertNil(theMap.spaceAt(x: 0, y: 11))
        XCTAssertEqual(SeatMap.Space.emptySeat, theMap.spaceAt(x: 0, y: 0))
    }

    func testSeatMapNearbyOccupiedSeatCount() {
        let theMap = SeatMap(testInput2)!
        XCTAssertEqual(0, theMap.nearbyOccupiedSeats(x: 2, y: 0))
        XCTAssertEqual(1, theMap.nearbyOccupiedSeats(x: 0, y: 0))
        XCTAssertEqual(2, theMap.nearbyOccupiedSeats(x: 1, y: 0))
        XCTAssertEqual(3, theMap.nearbyOccupiedSeats(x: 1, y: 4))
    }

    func testSeatMapOccupiedSeatCount() {
        let theMap = SeatMap(testFinalGeneration)!
        XCTAssertEqual(37, theMap.occupiedSeats)
    }

    func testSeatMapModelerGeneration() {
        let theMap = SeatMap(testInput)!
        let genOneMap = SeatMap(testGeneration1)!
        let genTwoMap = SeatMap(testGeneration2)!

        let modeler = SeatMapModeler(map: theMap)

        let gen1 = modeler.nextGeneration(map: theMap)
        XCTAssertEqual(genOneMap, gen1)

        let gen2 = modeler.nextGeneration(map: gen1)
        XCTAssertEqual(genTwoMap, gen2)
    }

    func testSeatModelerFinalGen() {
        let theMap = SeatMap(testInput)!
        let finalMap = SeatMap(testFinalGeneration)!

        let modeler = SeatMapModeler(map: theMap)

        let answer = modeler.findFinalGeneration()
        XCTAssertEqual(finalMap, answer)
    }

    let testInput = """
        L.LL.LL.LL
        LLLLLLL.LL
        L.L.L..L..
        LLLL.LL.LL
        L.LL.LL.LL
        L.LLLLL.LL
        ..L.L.....
        LLLLLLLLLL
        L.LLLLLL.L
        L.LLLLL.LL
        """

    let testInput2 = """
        #.LL.L#.##
        #LLLLLL.L#
        L.L.L..L..
        #LLL.LL.L#
        #.LL.LL.LL
        #.LLLL#.##
        ..L.L.....
        #LLLLLLLL#
        #.LLLLLL.L
        #.#LLLL.##
        """

    let testGeneration1 = """
        #.##.##.##
        #######.##
        #.#.#..#..
        ####.##.##
        #.##.##.##
        #.#####.##
        ..#.#.....
        ##########
        #.######.#
        #.#####.##
        """

    let testGeneration2 = """
        #.LL.L#.##
        #LLLLLL.L#
        L.L.L..L..
        #LLL.LL.L#
        #.LL.LL.LL
        #.LLLL#.##
        ..L.L.....
        #LLLLLLLL#
        #.LLLLLL.L
        #.#LLLL.##
        """
    let testFinalGeneration = """
        #.#L.L#.##
        #LLL#LL.L#
        L.#.L..#..
        #L##.##.L#
        #.#L.LL.LL
        #.#L#L#.##
        ..L.L.....
        #L#L##L#L#
        #.LLLLLL.L
        #.#L#L#.##
        """
}
