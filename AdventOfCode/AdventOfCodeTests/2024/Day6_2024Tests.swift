//
//  Day6_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/6/24.
//

import Testing

struct Day6_2024Tests {
    let sampleData = """
        ....#.....
        .........#
        ..........
        ..#.......
        .......#..
        ..........
        .#..^.....
        ........#.
        #.........
        ......#...
        """

    let day = Day6_2024()

    @Test func testParsingMap() async throws {
        let map = day.parse(sampleData)
        #expect(map.width == 10)
        #expect(map.height == 10)
        #expect(map.itemAt(x: 0, y: 0) == ".")
        #expect(map.itemAt(x: 4, y: 0) == "#")
    }

    @Test func creationOfPatrol() async throws {
        let patrol = day.createPatrol(sampleData)
        #expect(patrol.map.width == 10)
        #expect(patrol.map.height == 10)
        #expect(patrol.guardStartingPosition == Coordinate(x: 4, y: 6))
        #expect(patrol.guardCurrentPosition == Coordinate(x: 4, y: 6))
        #expect(patrol.guardOrientation == .north)
    }

    @Test func testPatrol() async throws {
        let patrol = day.createPatrol(sampleData)
        let visited = patrol.followGuard()
        #expect(visited.count == 41)
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer = try #require(day.partOne(input: sampleData) as? Int)
        #expect(answer == 41)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 5162)
    }
}
