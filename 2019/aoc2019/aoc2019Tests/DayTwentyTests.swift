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

    func testInnerOuter() {
        let maze = DonutMaze(input: testInput1)

        // FG
        XCTAssert(maze.isInner(portal: Coordinate(x: 11, y: 11)))
        XCTAssert(maze.isOuter(portal: Coordinate(x: 1, y: 15)))

        // DE
        XCTAssert(maze.isInner(portal: Coordinate(x: 7, y: 10)))
        XCTAssert(maze.isOuter(portal: Coordinate(x: 1, y: 13)))

        // BC
        XCTAssert(maze.isInner(portal: Coordinate(x: 9, y: 7)))
        XCTAssert(maze.isOuter(portal: Coordinate(x: 1, y: 8)))

        let maze2 = DonutMaze(input: testInput2)
        print(maze2.portalConnections)

        // VT
        XCTAssert(maze2.isInner(portal: Coordinate(x: 25, y: 23)))
        XCTAssert(maze2.isOuter(portal: Coordinate(x: 33, y: 11)))
    }

    func testRecursivePathFinding() {
        let maze = DonutMaze(input: testInput3)
        print(maze.portalConnections)
        print(maze.portals)
        let distance = maze.shortestPath(recursive: true)
        XCTAssertEqual(396, distance)
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

    let testInput3 = """
                                  Z L X W       C
                                  Z P Q B       K
                       ###########.#.#.#.#######.###############
                       #...#.......#.#.......#.#.......#.#.#...#
                       ###.#.#.#.#.#.#.#.###.#.#.#######.#.#.###
                       #.#...#.#.#...#.#.#...#...#...#.#.......#
                       #.###.#######.###.###.#.###.###.#.#######
                       #...#.......#.#...#...#.............#...#
                       #.#########.#######.#.#######.#######.###
                       #...#.#    F       R I       Z    #.#.#.#
                       #.###.#    D       E C       H    #.#.#.#
                       #.#...#                           #...#.#
                       #.###.#                           #.###.#
                       #.#....OA                       WB..#.#..ZH
                       #.###.#                           #.#.#.#
                     CJ......#                           #.....#
                       #######                           #######
                       #.#....CK                         #......IC
                       #.###.#                           #.###.#
                       #.....#                           #...#.#
                       ###.###                           #.#.#.#
                     XF....#.#                         RF..#.#.#
                       #####.#                           #######
                       #......CJ                       NM..#...#
                       ###.#.#                           #.###.#
                     RE....#.#                           #......RF
                       ###.###        X   X       L      #.#.#.#
                       #.....#        F   Q       P      #.#.#.#
                       ###.###########.###.#######.#########.###
                       #.....#...#.....#.......#...#.....#.#...#
                       #####.#.###.#######.#######.###.###.#.#.#
                       #.......#.......#.#.#.#.#...#...#...#.#.#
                       #####.###.#####.#.#.#.#.###.###.#.###.###
                       #.......#.....#.#...#...............#...#
                       #############.#.#.###.###################
                                    A O F   N
                                    A A D   M
                     """
}
