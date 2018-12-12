//
//  DayTenTests.swift
//  Test
//
//  Created by Shawn Veader on 12/11/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import XCTest

class DayTenTests: XCTestCase {

    let input = """
                position=< 9,  1> velocity=< 0,  2>
                position=< 7,  0> velocity=<-1,  0>
                position=< 3, -2> velocity=<-1,  1>
                position=< 6, 10> velocity=<-2, -1>
                position=< 2, -4> velocity=< 2,  2>
                position=<-6, 10> velocity=< 2, -2>
                position=< 1,  8> velocity=< 1, -1>
                position=< 1,  7> velocity=< 1,  0>
                position=<-3, 11> velocity=< 1, -2>
                position=< 7,  6> velocity=<-1, -1>
                position=<-2,  3> velocity=< 1,  0>
                position=<-4,  3> velocity=< 2,  0>
                position=<10, -3> velocity=<-1,  1>
                position=< 5, 11> velocity=< 1, -2>
                position=< 4,  7> velocity=< 0, -1>
                position=< 8, -2> velocity=< 0,  1>
                position=<15,  0> velocity=<-2,  0>
                position=< 1,  6> velocity=< 1,  0>
                position=< 8,  9> velocity=< 0, -1>
                position=< 3,  3> velocity=<-1,  1>
                position=< 0,  5> velocity=< 0, -1>
                position=<-2,  2> velocity=< 2,  0>
                position=< 5, -2> velocity=< 1,  2>
                position=< 1,  4> velocity=< 2,  1>
                position=<-2,  7> velocity=< 2, -2>
                position=< 3,  6> velocity=<-1, -1>
                position=< 5,  0> velocity=< 1,  0>
                position=<-6,  0> velocity=< 2,  0>
                position=< 5,  9> velocity=< 1, -2>
                position=<14,  7> velocity=<-2,  0>
                position=<-3,  6> velocity=< 2, -1>
                """

    func testLightParsing() {
        let day = DayTen()
        let lightInput = "position=< 9, -1> velocity=< 0,  2>"
        let lights = day.parse(input: lightInput)
        XCTAssertEqual(1, lights.count)

        let light = lights.first!
        XCTAssertEqual(9, light.position.x)
        XCTAssertEqual(-1, light.position.y)
        XCTAssertEqual(0, light.velocity.x)
        XCTAssertEqual(2, light.velocity.y)
    }

    func testLightMovement() {
        let day = DayTen()
        let lightInput = "position=<3, 9> velocity=<1, -2>"
        let lights = day.parse(input: lightInput)
        let light = lights.first!

        let movedLight = light.move(time: 3)
        XCTAssertEqual(6, movedLight.position.x)
        XCTAssertEqual(3, movedLight.position.y)
        XCTAssertEqual(1, movedLight.velocity.x)
        XCTAssertEqual(-2, movedLight.velocity.y)
    }

    func testSky() {
        let expected = """
                        ........#.............
                        ................#.....
                        .........#.#..#.......
                        ......................
                        #..........#.#.......#
                        ...............#......
                        ....#.................
                        ..#.#....#............
                        .......#..............
                        ......#...............
                        ...#...#.#...#........
                        ....#..#..#.........#.
                        .......#..............
                        ...........#..#.......
                        #...........#.........
                        ...#.......#..........

                        """

        let day = DayTen()
        let lights = day.parse(input: input)

        let sky = DayTen.Sky(lights: lights)

        let output = sky.debugDescription
        XCTAssertEqual(expected, output)
    }

    func testMovingSky() {
        let message = """
                        ......................
                        ......................
                        ......................
                        ......................
                        ......#...#..###......
                        ......#...#...#.......
                        ......#...#...#.......
                        ......#####...#.......
                        ......#...#...#.......
                        ......#...#...#.......
                        ......#...#...#.......
                        ......#...#..###......
                        ......................
                        ......................
                        ......................
                        ......................

                        """

        let day = DayTen()
        let lights = day.parse(input: input)

        var sky = DayTen.Sky(lights: lights)
        sky.tick()
        print(sky)
        print("----------------------------")
        sky.tick()
        print(sky)
        print("----------------------------")
        sky.tick()
        print(sky)
        print("----------------------------")

        let output = sky.debugDescription
        XCTAssertEqual(message, output)
    }
}
