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

    func testSeatMapVisibleSeatCount() {
        let theMap = SeatMap(testVisible1)!
        let answer = theMap.visibleOccupiedSeats(x: 3, y: 4)
        XCTAssertEqual(8, answer)
    }

    func testSeatMapVisibleOnSlope() {
        let theMap = SeatMap(testVisible1)!
        let y = 4
        let x = 3

        var seat = theMap.visibleSeat(x: x, y: y, slope: .upLeft)
        XCTAssertNotNil(seat)
        XCTAssertEqual(.occupiedSeat, seat?.space)
        XCTAssertEqual(1, seat?.x)
        XCTAssertEqual(2, seat?.y)

        seat = theMap.visibleSeat(x: x, y: y, slope: .up)
        XCTAssertNotNil(seat)
        XCTAssertEqual(.occupiedSeat, seat?.space)
        XCTAssertEqual(3, seat?.x)
        XCTAssertEqual(1, seat?.y)

        seat = theMap.visibleSeat(x: x, y: y, slope: .upRight)
        XCTAssertNotNil(seat)
        XCTAssertEqual(.occupiedSeat, seat?.space)
        XCTAssertEqual(7, seat?.x)
        XCTAssertEqual(0, seat?.y)

        seat = theMap.visibleSeat(x: x, y: y, slope: .right)
        XCTAssertNotNil(seat)
        XCTAssertEqual(.occupiedSeat, seat?.space)
        XCTAssertEqual(8, seat?.x)
        XCTAssertEqual(4, seat?.y)

        seat = theMap.visibleSeat(x: x, y: y, slope: .downRight)
        XCTAssertNotNil(seat)
        XCTAssertEqual(.occupiedSeat, seat?.space)
        XCTAssertEqual(4, seat?.x)
        XCTAssertEqual(5, seat?.y)

        seat = theMap.visibleSeat(x: x, y: y, slope: .down)
        XCTAssertNotNil(seat)
        XCTAssertEqual(.occupiedSeat, seat?.space)
        XCTAssertEqual(3, seat?.x)
        XCTAssertEqual(8, seat?.y)

        seat = theMap.visibleSeat(x: x, y: y, slope: .downLeft)
        XCTAssertNotNil(seat)
        XCTAssertEqual(.occupiedSeat, seat?.space)
        XCTAssertEqual(0, seat?.x)
        XCTAssertEqual(7, seat?.y)

        seat = theMap.visibleSeat(x: x, y: y, slope: .left)
        XCTAssertNotNil(seat)
        XCTAssertEqual(.occupiedSeat, seat?.space)
        XCTAssertEqual(2, seat?.x)
        XCTAssertEqual(4, seat?.y)
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

    func testSeatModelerFinalGenVisible() {
        let theMap = SeatMap(testInput)!
        let genOneMap = SeatMap(testGeneration1)!
        let genTwoMap = SeatMap(testGeneration2Visible)!
        let finalMap = SeatMap(testFinalGenerationVisible)!

        let modeler = SeatMapModeler(map: theMap)

        let gen1 = modeler.nextGeneration(map: theMap, visible: true)
        XCTAssertEqual(genOneMap, gen1)

        let gen2 = modeler.nextGeneration(map: gen1, visible: true)
        XCTAssertEqual(genTwoMap, gen2)

        let answer = modeler.findFinalGeneration(visible: true)
        print(answer)
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
    let testGeneration2Visible = """
        #.LL.LL.L#
        #LLLLLL.LL
        L.L.L..L..
        LLLL.LL.LL
        L.LL.LL.LL
        L.LLLLL.LL
        ..L.L.....
        LLLLLLLLL#
        #.LLLLLL.L
        #.LLLLL.L#
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

    let testFinalGenerationVisible = """
        #.L#.L#.L#
        #LLLLLL.LL
        L.L.L..#..
        ##L#.#L.L#
        L.L#.LL.L#
        #.LLLL#.LL
        ..#.L.....
        LLL###LLL#
        #.LLLLL#.L
        #.L#LL#.L#
        """

    let testVisible1 = """
        .......#.
        ...#.....
        .#.......
        .........
        ..#L....#
        ....#....
        .........
        #........
        ...#.....
        """
}
