//
//  Day20_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/24/24.
//

import Testing

struct Day20_2024Tests {
    let sampleData = """
        ###############
        #...#...#.....#
        #.#.#.#.#.###.#
        #S#...#.#.#...#
        #######.#.#.###
        #######.#.#...#
        #######.#.###.#
        ###..E#...#...#
        ###.#######.###
        #...###...#...#
        #.#####.#.###.#
        #.#...#.#.#...#
        #.#.#.#.#.#.###
        #...#...#...###
        ###############
        """

    let day = Day20_2024()

    @Test func testParsing() async throws {
        let maze = try #require(day.parse(sampleData))
        #expect(maze.width == 15)
        #expect(maze.height == 15)
        #expect(maze.start == Coordinate(x: 1, y: 3))
        #expect(maze.end == Coordinate(x: 5, y: 7))
    }

    @Test func testSolvingMaze() async throws {
        let maze = try #require(day.parse(sampleData))
        let solution = try #require(maze.crawlMaze())
        #expect(solution.score == 84)
        maze.printMaze(marking: solution.path.map { $0.location })
    }

    @Test func testShortcutFinding() async throws {
        let maze = try #require(day.parse(sampleData))
        let solution = try #require(maze.crawlMaze())
        let shortcuts = day.findShortcuts(maze: maze, score: solution)
        #expect(shortcuts.count == 44)

        #expect(shortcuts.count { $0.savings == 2 } == 14)
        #expect(shortcuts.count { $0.savings == 4 } == 14)
        #expect(shortcuts.count { $0.savings == 6 } == 2)
        #expect(shortcuts.count { $0.savings == 8 } == 4)
        #expect(shortcuts.count { $0.savings == 10 } == 2)
        #expect(shortcuts.count { $0.savings == 12 } == 3)

        let biggest = shortcuts.max { $0.savings < $1.savings }
        #expect(biggest?.savings == 64 )
    }

    // takes about 25s
//    @Test func testPartOne() async throws {
//        let answer = try await #require(day.run(part: 1) as? Int)
//        #expect(answer == 1358)
//    }

}
