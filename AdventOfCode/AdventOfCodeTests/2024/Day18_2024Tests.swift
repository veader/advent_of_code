//
//  Day18_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/23/24.
//

import Testing

struct Day18_2024Tests {
    let sampleData = """
        5,4
        4,2
        4,5
        3,0
        2,1
        6,3
        2,4
        1,5
        0,6
        3,3
        2,6
        5,1
        1,2
        5,5
        2,5
        6,5
        1,4
        0,4
        6,4
        1,1
        6,1
        1,0
        0,5
        1,6
        2,0
        """

    let day = Day18_2024()

    @Test func testParsingCoordinates() async throws {
        let coords = day.parse(sampleData)
        #expect(coords.count == 25)
        #expect(coords.first == Coordinate(x: 5, y: 4))
    }

    @Test func testMazeCreation() async throws {
        let coords = day.parse(sampleData)
        let maze = day.createMaze(coordinates: coords, count: 12, size: 7)
        let output = """
            S..#...
            ..#..#.
            ....#..
            ...#..#
            ..#..#.
            .#..#..
            #.#...E
            """
        #expect(maze == output)
    }

    @Test func solvingMaze() async throws {
        let coords = day.parse(sampleData)
        let mazeString = try #require(day.createMaze(coordinates: coords, count: 12, size: 7))
        let maze = try #require(Maze(input: mazeString, turnCost: 0))
        let solution = try #require(maze.crawlMaze())

        //        print(solution)
        //        for point in solution.path {
        //            maze.maze.update(at: point.location, with: .occupied)
        //        }
        //        maze.printMaze()

        #expect(solution.path.count == 23) // 23 - 1 (skip origin/start) == 22
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 310)
    }

    @Test func testFindingBlockingPoint() async throws {
        let coords = day.parse(sampleData)
        let mazeString = try #require(day.createMaze(coordinates: coords, count: 12, size: 7))
        let maze = try #require(Maze(input: mazeString, turnCost: 0))

        var idx = 12
        while idx < coords.count {
            //            print("\(idx) \(coords[idx])")
            maze.grid.update(at: coords[idx], with: .wall)
            if let _ = maze.crawlMaze() {
                idx += 1
                continue // still solvable, grab another point
            } else {
                break // no solution
            }
        }

        #expect(idx == 20)
        #expect(coords[idx] == Coordinate(x: 6, y: 1))
    }

    // takes about 104 seconds...
    //    @Test func testPartTwo() async throws {
    //        let answer = try await #require(day.run(part: 2) as? String)
    //        #expect(answer == "16,46")
    //    }
}
