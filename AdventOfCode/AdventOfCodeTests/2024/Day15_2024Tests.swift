//
//  Day15_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/16/24.
//

import Testing

struct Day15_2024Tests {
    let sampleData1 = """
        ##########
        #..O..O.O#
        #......O.#
        #.OO..O.O#
        #..O@..O.#
        #O#..O...#
        #O..O..O.#
        #.OO.O.OO#
        #....O...#
        ##########

        <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
        vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
        ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
        <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
        ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
        ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
        >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
        <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
        ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
        v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
        """
    let sampleData2 = """
        ########
        #..O.O.#
        ##@.O..#
        #...O..#
        #.#.O..#
        #...O..#
        #......#
        ########

        <^^>>>vv<v>>v<<
        """

    let day = Day15_2024()

    @Test func testWarehouseParsing() async throws {
        let warehouse1 = day.parse(sampleData1)
//        print(warehouse1.map.gridAsString { $0?.rawValue ?? "?" })
        #expect(warehouse1.map.width == 10)
        #expect(warehouse1.map.height == 10)
        #expect(warehouse1.moves.count > 70) // more than the first line
        #expect(warehouse1.moves.count == 700)
        #expect(warehouse1.botPosition == Coordinate(x: 4, y: 4))

        let warehouse2 = day.parse(sampleData2)
//        print(warehouse2.map.gridAsString { $0?.rawValue ?? "?" })
        #expect(warehouse2.map.width == 8)
        #expect(warehouse2.map.height == 8)
        #expect(warehouse2.moves.count == 15)
        #expect(warehouse2.botPosition == Coordinate(x: 2, y: 2))
    }

    @Test func testSimpleRobotMovement() async throws {
        let warehouse = day.parse(sampleData2)
        warehouse.shouldPrint = false
        #expect(warehouse.botPosition == Coordinate(x: 2, y: 2))
        warehouse.followMoves()
        #expect(warehouse.botPosition == Coordinate(x: 4, y: 4))
    }

    @Test func testSampleDataBotMovement() async throws {
        let warehouse = day.parse(sampleData1)
        warehouse.shouldPrint = false
        #expect(warehouse.botPosition == Coordinate(x: 4, y: 4))
        warehouse.followMoves()
        #expect(warehouse.botPosition == Coordinate(x: 3, y: 4))
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer2 = try await #require(day.partOne(input: sampleData2) as? Int)
        #expect(answer2 == 2028)

        let answer1 = try await #require(day.partOne(input: sampleData1) as? Int)
        #expect(answer1 == 10092)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 1448589)
    }
}
