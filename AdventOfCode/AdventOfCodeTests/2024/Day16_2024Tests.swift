//
//  Day16_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/17/24.
//

import Testing

struct Day16_2024Tests {
    let sampleData1 = """
        ###############
        #.......#....E#
        #.#.###.#.###.#
        #.....#.#...#.#
        #.###.#####.#.#
        #.#.#.......#.#
        #.#.#####.###.#
        #...........#.#
        ###.#.#####.#.#
        #...#.....#.#.#
        #.#.#.###.#.#.#
        #.....#...#.#.#
        #.###.#.#.#.#.#
        #S..#.....#...#
        ###############
        """

    let sampleData2 = """
        #################
        #...#...#...#..E#
        #.#.#.#.#.#.#.#.#
        #.#.#.#...#...#.#
        #.#.#.#.###.#.#.#
        #...#.#.#.....#.#
        #.#.#.#.#.#####.#
        #.#...#.#.#.....#
        #.#.#####.#.###.#
        #.#.#.......#...#
        #.#.###.#####.###
        #.#.#...#.....#.#
        #.#.#.#####.###.#
        #.#.#.........#.#
        #.#.#.#########.#
        #S#.............#
        #################
        """

    let day = Day16_2024()

    @Test func testMazeParsing() async throws {
        let maze1 = try #require(day.parse(sampleData1))
        #expect(maze1.width == 15)
        #expect(maze1.height == 15)
        #expect(maze1.start == Coordinate(x: 1, y: 13))
        #expect(maze1.end == Coordinate(x: 13, y: 1))

        let maze2 = try #require(day.parse(sampleData2))
        #expect(maze2.width == 17)
        #expect(maze2.height == 17)
        #expect(maze2.start == Coordinate(x: 1, y: 15))
        #expect(maze2.end == Coordinate(x: 15, y: 1))
    }

    @Test func testMazeCrawlingSimple() async throws {
        let maze = try #require(day.parse(sampleData1))
        let endScore = try #require(maze.crawlMaze())
        #expect(endScore.score == 7036)
    }

    @Test func testMazeCrawlingHarderMaze() async throws {
        let maze = try #require(day.parse(sampleData2))
        let endScore = try #require(maze.crawlMaze())
        #expect(endScore.score == 11048)
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer = try await #require(day.partOne(input: sampleData1) as? Int)
        #expect(answer == 7036)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 90460)
    }
}
