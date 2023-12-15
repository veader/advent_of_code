//
//  Day14_2023Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/14/23.
//

import XCTest

final class Day14_2023Tests: XCTestCase {

    let sampleInput = """
        O....#....
        O.OO#....#
        .....##...
        OO.#O....O
        .O.....O#.
        O.#..O.#.#
        ..O..#O..O
        .......O..
        #....###..
        #OO..#....
        """

    let sampleAfter = """
        OOOO.#.O..
        OO..#....#
        OO..O##..O
        O..#.OO...
        ........#.
        ..#....#.#
        ..O..#.O.O
        ..O.......
        #....###..
        #....#....
        """

    let sampleAfterSpin1 = """
        .....#....
        ....#...O#
        ...OO##...
        .OO#......
        .....OOO#.
        .O#...O#.#
        ....O#....
        ......OOOO
        #...O###..
        #..OO#....
        """

    let sampleAfterSpin3 = """
        .....#....
        ....#...O#
        .....##...
        ..O#......
        .....OOO#.
        .O#...O#.#
        ....O#...O
        .......OOO
        #...O###.O
        #.OOO#...O
        """

    func convertToMirrorPoints(_ input: String) -> [ReflectorDish.MirrorPoint] {
        input.charSplit().compactMap(ReflectorDish.MirrorPoint.init)
    }

    func testRollFunction() {
        let dish = ReflectorDish("")
        var rowBefore = convertToMirrorPoints("OO.O.O..##")
        var rowAfter = convertToMirrorPoints("OOOO....##")
        var answer = dish.roll(rowBefore)
        XCTAssertEqual(answer, rowAfter)

        rowBefore = convertToMirrorPoints(".O...#O..O")
        rowAfter = convertToMirrorPoints("O....#OO..")
        answer = dish.roll(rowBefore)
        XCTAssertEqual(answer, rowAfter)
    }

    func testDishTilt() throws {
        let dish = ReflectorDish(sampleInput)
        dish.tilt()

        let dishAfter = ReflectorDish(sampleAfter)
        XCTAssertEqual(dish.data.gridAsString(), dishAfter.data.gridAsString())
    }

    func testDishLoadCalculations() throws {
        let dish = ReflectorDish(sampleInput)
        dish.tilt()
        let load = dish.calculateLoad()
        XCTAssertEqual(136, load)
    }

    func testPart1() throws {
        let answer = Day14_2023().run(part: 1, sampleInput)
        XCTAssertEqual(136, answer as? Int)
    }

    func testPart1Answer() throws {
        let answer = Day14_2023().run(part: 1)
        XCTAssertEqual(109466, answer as? Int)
    }

    func testDishSpin() throws {
        let dish = ReflectorDish(sampleInput)
        dish.spin()

        let dishAfter = ReflectorDish(sampleAfterSpin1)
        XCTAssertEqual(dish.data.gridAsString(), dishAfter.data.gridAsString())
    }

    func testDishSpinMore() throws {
        let dish = ReflectorDish(sampleInput)
        dish.spinCycle(count: 3)

        let dishAfter = ReflectorDish(sampleAfterSpin3)
        XCTAssertEqual(dish.data.gridAsString(), dishAfter.data.gridAsString())
    }

    func xtestDishLotsOfSpins() throws {
        let dish = ReflectorDish(sampleInput)
        print(Date.now)
        dish.spinCycle(count: 1_000_000_000)
        // takes too long... 50s/spin cycle
        print(Date.now)
        let load = dish.calculateLoad()
        XCTAssertEqual(64, load)
    }
}
