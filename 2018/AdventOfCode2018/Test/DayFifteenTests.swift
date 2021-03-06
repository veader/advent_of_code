//
//  DayFifteenTests.swift
//  Test
//
//  Created by Shawn Veader on 12/18/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import XCTest

class DayFifteenTests: XCTestCase {

    let input1 = """
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

    let input3 = """
                #########
                #G..G..G#
                #.......#
                #.......#
                #G..E..G#
                #.......#
                #.......#
                #G..G..G#
                #########
                """

    func linesFrom(input: String) -> [String] {
        return input.split(separator: "\n")
                    .map(String.init)
                    .map { $0.trimmingCharacters(in: .newlines) }
    }

    func testMapParsing() {
        let map = DayFifteen.CaveMap(input: linesFrom(input: input1))
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
        let map = DayFifteen.CaveMap(input: linesFrom(input: input1))
        let c = Coordinate(x: 2, y: 1)
        let emptySpots = map.emptyAdjacentSpots(around: c)
        XCTAssertEqual(3, emptySpots.count)
        XCTAssert(emptySpots.contains(Coordinate(x: 1, y: 1)))
        XCTAssert(emptySpots.contains(Coordinate(x: 3, y: 1)))
        XCTAssert(emptySpots.contains(Coordinate(x: 2, y: 2)))

        let map2 = DayFifteen.CaveMap(input: linesFrom(input: input2))
        let c2 = Coordinate(x: 4, y: 1)
        let emptySpots2 = map2.emptyAdjacentSpots(around: c2)
        XCTAssertEqual(2, emptySpots2.count)
        XCTAssert(emptySpots2.contains(Coordinate(x: 3, y: 1)))
        XCTAssert(emptySpots2.contains(Coordinate(x: 5, y: 1)))
    }

    func testAttackingOrder() {
        let attackInput = """
                        #######
                        #...#E#
                        #E#...#
                        #GE##.#
                        #E..#E#
                        #.....#
                        #######
                        """
        let map = DayFifteen.CaveMap(input: linesFrom(input: attackInput))
        let goblin = map.creatures.first(where: { $0.creatureType == .goblin })
        let mapResponse = map.nextDestinations(for: goblin!)
        XCTAssertNil(mapResponse)

        let attackResponse = map.attackableEnemies(of: goblin!)
        XCTAssertEqual(3, attackResponse?.count)
        XCTAssertEqual(Coordinate(x: 1, y: 2), attackResponse?.first?.position)
    }

    func testTakeTurn() {
        var map = DayFifteen.CaveMap(input: linesFrom(input: input3))

        map.takeTurn()
        print(map.printable())
        print("\n")

        map.takeTurn()
        print(map.printable())
        print("\n")

        map.takeTurn()
        print(map.printable())
        print("\n")
    }

    func testRunSimulation1() {
        let input4 = """
                #######
                #.G...#
                #...EG#
                #.#.#G#
                #..G#E#
                #.....#
                #######
                """
        var map = DayFifteen.CaveMap(input: linesFrom(input: input4))
        let outcome = map.runSimulation()
        XCTAssertEqual(27730, outcome)
    }

    func testRunSimulation2() {
        let input5 = """
                    #######
                    #G..#E#
                    #E#E.E#
                    #G.##.#
                    #...#E#
                    #...E.#
                    #######
                    """
        var map = DayFifteen.CaveMap(input: linesFrom(input: input5))
        let outcome = map.runSimulation()
        XCTAssertEqual(36334, outcome)
    }

    func testRunSimulation3() {
        let input6 = """
                    #######
                    #E..EG#
                    #.#G.E#
                    #E.##E#
                    #G..#.#
                    #..E#.#
                    #######
                    """
        var map = DayFifteen.CaveMap(input: linesFrom(input: input6))
        let outcome = map.runSimulation()
        XCTAssertEqual(39514, outcome)
    }

    func testRunSimulation4() {
        let input7 = """
                    #######
                    #E.G#.#
                    #.#G..#
                    #G.#.G#
                    #G..#.#
                    #...E.#
                    #######
                    """
        var map = DayFifteen.CaveMap(input: linesFrom(input: input7))
        let outcome = map.runSimulation()
        XCTAssertEqual(27755, outcome)
    }

    func testRunSimulation5() {
        let input8 = """
                    #########
                    #G......#
                    #.E.#...#
                    #..##..G#
                    #...##..#
                    #...#...#
                    #.G...G.#
                    #.....G.#
                    #########
                    """
        var map = DayFifteen.CaveMap(input: linesFrom(input: input8))
        let outcome = map.runSimulation()
        XCTAssertEqual(18740, outcome)
    }

    func testMoveMap() {
        let map = DayFifteen.CaveMap(input: linesFrom(input: input2))
        let elf = map.creatures.first(where: { $0.creatureType == .elf })
        let mapResponse = map.nextDestinations(for: elf!)
        XCTAssertEqual(3, mapResponse?.destinations.count)
        XCTAssertEqual(Coordinate(x: 3, y: 1), mapResponse?.destinations.first)
    }

}
