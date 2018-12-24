//
//  DayFifteenTests.swift
//  Test
//
//  Created by Shawn Veader on 12/18/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import XCTest

class DayFifteenTests: XCTestCase {

    let input = """
                #######
                #.G.E.#
                #E.G.E#
                #.G.E.#
                #######
                """

    let input2 = """
                #######
                #E..G.#
                #...#.#
                #.G.#G#
                #######
                """

    func testMapParsing() {
        let lines = input.split(separator: "\n").map(String.init).map { $0.trimmingCharacters(in: .newlines) }

        let map = DayFifteen.CaveMap(input: lines)
        XCTAssertEqual(7, map.creatures.count)
        XCTAssertEqual(15, map.map.reduce(0, { result, row in
            return result + row.filter({ $0 == .empty }).count
        }))
        XCTAssertEqual(4, map.creatures.filter({ $0.creatureType == .elf }).count)
        XCTAssertEqual(3, map.creatures.filter({ $0.creatureType == .goblin }).count)

        let printableMap = map.printable()
        print(printableMap)

        XCTAssert(true)
    }

    func testAdjacentSpots() {
        let lines = input.split(separator: "\n").map(String.init).map { $0.trimmingCharacters(in: .newlines) }
        let lines2 = input2.split(separator: "\n").map(String.init).map { $0.trimmingCharacters(in: .newlines) }

        let map = DayFifteen.CaveMap(input: lines)
        let c = Coordinate(x: 2, y: 1)
        let emptySpots = map.emptyAdjacentSpots(around: c)
        XCTAssertEqual(3, emptySpots.count)
        XCTAssert(emptySpots.contains(Coordinate(x: 1, y: 1)))
        XCTAssert(emptySpots.contains(Coordinate(x: 3, y: 1)))
        XCTAssert(emptySpots.contains(Coordinate(x: 2, y: 2)))

        let map2 = DayFifteen.CaveMap(input: lines2)
        let c2 = Coordinate(x: 4, y: 1)
        let emptySpots2 = map2.emptyAdjacentSpots(around: c2)
        XCTAssertEqual(2, emptySpots2.count)
        XCTAssert(emptySpots2.contains(Coordinate(x: 3, y: 1)))
        XCTAssert(emptySpots2.contains(Coordinate(x: 5, y: 1)))
    }

    func testTakeTurn() {
        let lines = input2.split(separator: "\n").map(String.init).map { $0.trimmingCharacters(in: .newlines) }
        var map = DayFifteen.CaveMap(input: lines)
        map.takeTurn()
    }

    func testMoveMap() {
        let lines = input2.split(separator: "\n").map(String.init).map { $0.trimmingCharacters(in: .newlines) }
        let map = DayFifteen.CaveMap(input: lines)
        let elf = map.creatures.first(where: { $0.creatureType == .elf })
        let destinations = map.nextDestinations(for: elf!)
        XCTAssertEqual(3, destinations?.count)
        XCTAssertEqual(Coordinate(x: 3, y: 1), destinations?.first)
    }

}
