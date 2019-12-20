//
//  DayTwentyTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/20/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DayTwentyTests: XCTestCase {

    func testMapParsing() {
        let maze = DonutMaze(input: testInput1)
        print(maze.portalConnections)
        XCTAssertEqual(3, maze.portalConnections.count)

        XCTAssertNotNil(maze.start)
        XCTAssertEqual(Coordinate(x: 9, y: 2), maze.start)

        XCTAssertNotNil(maze.goal)
        XCTAssertEqual(Coordinate(x: 13, y: 16), maze.goal)
    }

    func testPathFinding() {
        let maze = DonutMaze(input: testInput1)
        let distance = maze.shortestPath()
        XCTAssertEqual(23, distance)

        let maze2 = DonutMaze(input: testInput2)
        let distance2 = maze2.shortestPath()
        XCTAssertEqual(58, distance2)
    }

    func testPartOneAnswer() {
        let day = DayTwenty()
        let answer = day.run(part: 1) as! Int
        XCTAssertEqual(454, answer)
    }

    func testPartTwoAnswer() {
        XCTAssert(true)
//        let day = DayFourteen()
//        let answer = day.run(part: 2) as! Int
//        XCTAssertEqual(416, answer)
    }

    let testInput1 = """
                              A
                              A
                       #######.#########
                       #######.........#
                       #######.#######.#
                       #######.#######.#
                       #######.#######.#
                       #####  B    ###.#
                     BC...##  C    ###.#
                       ##.##       ###.#
                       ##...DE  F  ###.#
                       #####    G  ###.#
                       #########.#####.#
                     DE..#######...###.#
                       #.#########.###.#
                     FG..#########.....#
                       ###########.#####
                                  Z
                                  Z
                     """

    let testInput2 = """
                                        A
                                        A
                       #################.#############
                       #.#...#...................#.#.#
                       #.#.#.###.###.###.#########.#.#
                       #.#.#.......#...#.....#.#.#...#
                       #.#########.###.#####.#.#.###.#
                       #.............#.#.....#.......#
                       ###.###########.###.#####.#.#.#
                       #.....#        A   C    #.#.#.#
                       #######        S   P    #####.#
                       #.#...#                 #......VT
                       #.#.#.#                 #.#####
                       #...#.#               YN....#.#
                       #.###.#                 #####.#
                     DI....#.#                 #.....#
                       #####.#                 #.###.#
                     ZZ......#               QG....#..AS
                       ###.###                 #######
                     JO..#.#.#                 #.....#
                       #.#.#.#                 ###.#.#
                       #...#..DI             BU....#..LF
                       #####.#                 #.#####
                     YN......#               VT..#....QG
                       #.###.#                 #.###.#
                       #.#...#                 #.....#
                       ###.###    J L     J    #.#.###
                       #.....#    O F     P    #.#...#
                       #.###.#####.#.#####.#####.###.#
                       #...#.#.#...#.....#.....#.#...#
                       #.#####.###.###.#.#.#########.#
                       #...#.#.....#...#.#.#.#.....#.#
                       #.###.#####.###.###.#.#.#######
                       #.#.........#...#.............#
                       #########.###.###.#############
                                B   J   C
                                U   P   P
                     """
}
