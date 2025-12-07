//
//  DaySeven2025.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/7/25.
//

import Testing

struct DaySeven2025 {
    let day = Day7_2025()
    let sampleInput = """
        .......S.......
        ...............
        .......^.......
        ...............
        ......^.^......
        ...............
        .....^.^.^.....
        ...............
        ....^.^...^....
        ...............
        ...^.^...^.^...
        ...............
        ..^...^.....^..
        ...............
        .^.^.^.^.^...^.
        ...............
        """

    let testRunInput = """
        .......S.......
        .......|.......
        ......|^|......
        ......|.|......
        .....|^|^|.....
        .....|.|.|.....
        ....|^|^|^|....
        ....|.|.|.|....
        ...|^|^|||^|...
        ...|.|.|||.|...
        ..|^|^|||^|^|..
        ..|.|.|||.|.|..
        .|^|||^||.||^|.
        .|.|||.||.||.|.
        |^|^|^|^|^|||^|
        |.|.|.|.|.|||.|
        """

    @Test func testParsingTeleportMap() async throws {
        let map = try #require(TeleportMap.parse(input: sampleInput))

        #expect(map.map.itemAt(x: 0, y: 0) == .empty)
        #expect(map.map.itemAt(x: 7, y: 0) == .start)
        #expect(map.map.itemAt(x: 7, y: 2) == .splitter)

        #expect(map.startLocation == Coordinate(x: 7, y: 0))
    }

    @Test func testTracingBeams() async throws {
        let map = try #require(TeleportMap.parse(input: sampleInput))

        let splits = map.traceTachyons()
        let postRunGrid = map.map.gridAsString()
        // print(postRunGrid)

        let finalMap = try #require(TeleportMap.parse(input: testRunInput))
        let testFinalGrid = finalMap.map.gridAsString()

        #expect(postRunGrid == testFinalGrid)
        #expect(splits == 21)
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer = try #require(day.partOne(input: sampleInput) as? Int)
        #expect(answer == 21)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 1600)
    }

}
