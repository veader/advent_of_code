//
//  Day4_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/4/24.
//

import Testing

struct Day4_2024Tests {

    let sampleData = """
        MMMSXXMASM
        MSAMXMSMSA
        AMXSXMAAMM
        MSAMASMSMX
        XMASAMXAMM
        XXAMMXXAMA
        SMSMSASXSS
        SAXAMASAAA
        MAMMMXMMMM
        MXMXAXMASX
        """

    let day = Day4_2024()

    @Test func testParsingOfGridMap() async throws {
        let grid = day.parse(sampleData)
        #expect(grid.xBounds == 0..<10)
        #expect(grid.yBounds == 0..<10)
        #expect(grid.item(at: Coordinate(x: 0, y: 0)) == "M")
        #expect(grid.item(at: Coordinate(x: 9, y: 0)) == "M")
        #expect(grid.item(at: Coordinate(x: 0, y: 9)) == "M")
        #expect(grid.item(at: Coordinate(x: 9, y: 9)) == "X")
        #expect(grid.gridAsString() == sampleData)
    }

    @Test func testFindingXMASInGrid() async throws {
        let grid = day.parse(sampleData)

        let eastCoords = try #require(day.isXMAS(in: grid, starting: Coordinate(x:5, y:0), traveling: .east))
        #expect(!eastCoords.isEmpty)

        let southEastCoords = try #require(day.isXMAS(in: grid, starting: Coordinate(x:4, y:0), traveling: .southEast))
        #expect(!southEastCoords.isEmpty)

        let westCoords = try #require(day.isXMAS(in: grid, starting: Coordinate(x:4, y:1), traveling: .west))
        #expect(!westCoords.isEmpty)
    }

    @Test func testFindingXMAS() async throws {
        let grid = day.parse(sampleData)

        let answers = day.findXMAS(in: grid)
        #expect(answers.count == 18)
    }

    @Test func testPartOneWithSampleData() async throws {
        let answers = try #require(day.partOne(input: sampleData) as? Int)
        #expect(answers == 18)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 2504)
    }

    @Test func testFindingMASXInGrid() async throws {
        let grid = day.parse(sampleData)

        let coords1 = try #require(day.isMASX(in: grid, centeredOn: Coordinate(x: 2, y: 1)))
        #expect(!coords1.isEmpty)

        let coords2 = try #require(day.isMASX(in: grid, centeredOn: Coordinate(x: 7, y: 2)))
        #expect(!coords2.isEmpty)
    }

    @Test func testFindingMASX() async throws {
        let grid = day.parse(sampleData)
        
        let answers = day.findMASinX(in: grid)
        #expect(answers.count == 9)
    }

    @Test func testPartTwoWithSampleData() async throws {
        let answers = try #require(day.partTwo(input: sampleData) as? Int)
        #expect(answers == 9)
    }

    @Test func testPartTwo() async throws {
        let answer = try await #require(day.run(part: 2) as? Int)
        #expect(answer == 1923)
    }
}
