//
//  DayTwelveTests.swift
//  Test
//
//  Created by Shawn Veader on 12/13/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import XCTest

class DayTwelveTests: XCTestCase {

    let testInput = """
                    initial state: #..#.#..##......###...###

                    ...## => #
                    ..#.. => #
                    .#... => #
                    .#.#. => #
                    .#.## => #
                    .##.. => #
                    .#### => #
                    #.#.# => #
                    #.### => #
                    ##.#. => #
                    ##.## => #
                    ###.. => #
                    ###.# => #
                    ####. => #
                    """

    func testInputParsing() {
        let day = DayTwelve()
        let results = day.parse(input: testInput)
        XCTAssertEqual("#..#.#..##......###...###", results?.startingCondition)

        XCTAssertEqual(14, results?.growthRules.count)

        guard let grows = results?.growthRules["##.##"] else { XCTFail("Unable to find rule"); return }
        XCTAssertTrue(grows)
    }

    func testPlantGeneration() {
        let start = "#..#.#..##......###...###"
        let generation = DayTwelve.PlantGeneration(initial: start)

        XCTAssertEqual(0, generation.zeroIndex)

        XCTAssertTrue(generation.plantMap[0] ?? false)
        XCTAssertTrue(generation.plantMap[3] ?? false)

        XCTAssertFalse(generation.plantMap[1] ?? false)

        let output = generation.printable(start: -2)
        XCTAssertEqual("..\(start).", output)
    }

    func testPlantGenerationSubSequence() {
        let start = "#..#.#..##......###...###"
        let generation = DayTwelve.PlantGeneration(initial: start)

        var sub = generation.subSequence(center: 0)
        XCTAssertEqual("..#..", sub)

        sub = generation.subSequence(center: 1)
        XCTAssertEqual(".#..#", sub)

        sub = generation.subSequence(center: 2)
        XCTAssertEqual("#..#.", sub)

        sub = generation.subSequence(center: 24)
        XCTAssertEqual("###..", sub)
    }

    func testNextGeneration() {
        let day = DayTwelve()
        guard let initialPlantInfo = day.parse(input: testInput) else {
            XCTFail("Unable to parse input")
            return
        }

        let generation = DayTwelve.PlantGeneration(initial: initialPlantInfo.startingCondition)
        let nextGeneration = generation.nextGeneration(given: initialPlantInfo.growthRules)

        XCTAssertEqual("..#...#....#.....#..#..#..#..", nextGeneration?.generation)
        XCTAssertEqual(2, nextGeneration?.zeroIndex)
    }

    func testOffsetStartIndex() {
        let input = ".#.#..#...#.#...##...#...#.#..##..##..."
        let zeroIndex = 3
        let generation = DayTwelve.PlantGeneration(initial: input, zeroIndex: zeroIndex)
        XCTAssertEqual(zeroIndex, generation.zeroIndex)
        XCTAssertEqual("#.#..", generation.subSequence(center: 0))

        XCTAssertEqual("#.#..#...#.#...##...#...#.#..##..##.", generation.printable())
    }

    func testPartOne() {
        let day = DayTwelve()
        guard let initialPlantInfo = day.parse(input: testInput) else {
            XCTFail("Unable to parse input")
            return
        }

        XCTAssertEqual(325, day.partOne(info: initialPlantInfo))
    }
}
