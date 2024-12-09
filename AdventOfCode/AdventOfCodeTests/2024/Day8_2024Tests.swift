//
//  Day8_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/8/24.
//

import Testing

struct Day8_2024Tests {
    let sampleData1 = """
        ..........
        ..........
        ..........
        ....a.....
        ..........
        .....a....
        ..........
        ..........
        ..........
        ..........
        """
    let sampleData2 = """
        ..........
        ..........
        ..........
        ....a.....
        ........a.
        .....a....
        ..........
        ..........
        ..........
        ..........
        """

    let sampleData3 = """
        ............
        ........0...
        .....0......
        .......0....
        ....0.......
        ......A.....
        ............
        ............
        ........A...
        .........A..
        ............
        ............
        """

    let sampleData4 = """
        T.........
        ...T......
        .T........
        ..........
        ..........
        ..........
        ..........
        ..........
        ..........
        ..........
        """

    let day = Day8_2024()

    @Test func testGridDeltaMath() async throws {
        let c1 = Coordinate(x: 4, y: 3)
        let c2 = Coordinate(x: 5, y: 5)

        let delta = c1.delta(to: c2, originTopLeft: true)
        #expect(delta.x == 1)
        #expect(delta.y == 2)

        let op = delta.opposite
        #expect(op.x == -1)
        #expect(op.y == -2)

        let c3 = c1.applying(delta: op, originTopLeft: true)
        #expect(c3 == Coordinate(x: 3, y: 1))

        let c4 = c1.applying(delta: delta, originTopLeft: true)
        #expect(c4 == c2)
    }

    @Test func testParsingAntennadMap() async throws {
        let map = day.parse(sampleData1)
        #expect(map.map.width == 10)
        #expect(map.map.height == 10)
        #expect(map.frequencies.count == 1)
        #expect(map.frequencies.first == "a")
        #expect(map.antennas["a"]?.count == 2)
    }

    @Test func testFindingAntinodesSingleFreq() async throws {
        let map = day.parse(sampleData1)
        let nodes = map.findAntinodes(for: "a")
        #expect(nodes.count == 2)
        #expect(nodes.contains(Coordinate(x: 3, y: 1)))
        #expect(nodes.contains(Coordinate(x: 6, y: 7)))

        let map2 = day.parse(sampleData2)
        let nodes2 = map2.findAntinodes(for: "a")
        #expect(nodes2.count == 4)
    }

    @Test func testFindingAntinodes() async throws {
        let map = day.parse(sampleData3)
        let nodes = map.findAntinodes()
        #expect(nodes.count == 14)
    }

    @Test func testPartOneWithSampleData() async throws {
        let nodes = try #require(day.partOne(input: sampleData3) as? Int)
        #expect(nodes == 14)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 329)
    }

    @Test func testFindingAntinodesWithHarmonics() async throws {
        let map = day.parse(sampleData4)
        let nodes = map.findAntinodes(withHarmonics: true)
        #expect(nodes.count == 9)

        let map2 = day.parse(sampleData3)
        let nodes2 = map2.findAntinodes(withHarmonics: true)
        #expect(nodes.count == 34)
    }

    @Test func testPartTwoWithSampleData() async throws {
        let nodes = try #require(day.partTwo(input: sampleData3) as? Int)
        #expect(nodes == 34)
    }

    @Test func testPartTwo() async throws {
        let answer = try await #require(day.run(part: 2) as? Int)
        #expect(answer == 1190)
    }
}
