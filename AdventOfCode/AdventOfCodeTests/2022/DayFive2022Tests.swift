//
//  DayFive2022Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/5/22.
//

import XCTest

final class DayFive2022Tests: XCTestCase {

    let sampleBoxInput = """
            [D]
        [N] [C]
        [Z] [M] [P]
        """

    let sampleInput = """
            [D]
        [N] [C]
        [Z] [M] [P]
         1   2   3

        move 1 from 2 to 1
        move 3 from 1 to 3
        move 2 from 2 to 1
        move 1 from 1 to 2
        """

    func testParsingBoxes() {
        let matches = "    [D]".matches(of: SupplyCrateMap.boxColumnRegex)
        XCTAssertNotNil(matches)
        XCTAssertEqual(2, matches.count)
        XCTAssertNil(matches[0].1)
        XCTAssertEqual("D", matches[1].1)

        let moreMatches = "[Z] [M] [P]".matches(of: SupplyCrateMap.boxColumnRegex)
        XCTAssertNotNil(moreMatches)
        XCTAssertEqual(3, moreMatches.count)
        XCTAssertEqual("Z", moreMatches[0].1)
        XCTAssertEqual("M", moreMatches[1].1)
        XCTAssertEqual("P", moreMatches[2].1)
    }

    func testBoxStackParsing() {
        let map = SupplyCrateMap.parse(sampleBoxInput)
        XCTAssertEqual(3, map.stack.count)
        XCTAssertEqual(SupplyCrateMap.SupplyBox.empty, map.stack[0][0])
        XCTAssertEqual(SupplyCrateMap.SupplyBox.box("D"), map.stack[0][1])
        XCTAssertEqual(SupplyCrateMap.SupplyBox.empty, map.stack[0][2])

        let map2 = SupplyCrateMap.parse(sampleInput)
        XCTAssertEqual(3, map2.stack.count)
        XCTAssertEqual(SupplyCrateMap.SupplyBox.empty, map2.stack[0][0])
        XCTAssertEqual(SupplyCrateMap.SupplyBox.box("D"), map2.stack[0][1])
        XCTAssertEqual(SupplyCrateMap.SupplyBox.empty, map2.stack[0][2])
    }

    func testInstructionParsing() {
        let map = SupplyCrateMap.parse(sampleInput)
        XCTAssertEqual(4, map.instructions.count)

        let first = map.instructions.first!
        XCTAssertEqual(1, first.moveAmount)
        XCTAssertEqual(2, first.originIndex)
        XCTAssertEqual(1, first.destinationIndex)
    }

    func testColumnIndices() {
        let map = SupplyCrateMap.parse(sampleInput)

        let firstIndices = map.column(0)
        XCTAssertEqual(3, firstIndices.count)
        print(firstIndices)

        let lastIndices = map.column(2)
        XCTAssertEqual(3, lastIndices.count)
    }

    func testTopIndex() {
        let map = SupplyCrateMap.parse(sampleInput)
        XCTAssertEqual(1, map.topIndex(column: 0))
        XCTAssertEqual(0, map.topIndex(column: 1))
        XCTAssertEqual(2, map.topIndex(column: 2))
    }

    func testInstruction() {
        var map = SupplyCrateMap.parse(sampleInput)

        map.follow(instruction: map.instructions.first!)

        XCTAssertEqual(0, map.topIndex(column: 0))
        XCTAssertEqual(1, map.topIndex(column: 1))
        XCTAssertEqual(2, map.topIndex(column: 2))
    }

    func testAllInstruction() {
        var map = SupplyCrateMap.parse(sampleInput)
        map.followAllInstructions()

        XCTAssertEqual(3, map.topIndex(column: 0))
        XCTAssertEqual(3, map.topIndex(column: 1))
        XCTAssertEqual(0, map.topIndex(column: 2))
    }

    func testAllGroupedInstructions() {
        var map = SupplyCrateMap.parse(sampleInput)
        map.followAllInstructions(grouped: true)

        XCTAssertEqual(3, map.topIndex(column: 0))
        XCTAssertEqual(3, map.topIndex(column: 1))
        XCTAssertEqual(0, map.topIndex(column: 2))
        map.printStack()
    }

    func testTopBoxes() {
        var map = SupplyCrateMap.parse(sampleInput)
        map.followAllInstructions()
        let tops = map.topBoxes()
        XCTAssertEqual(.box("C"), tops[0])
        XCTAssertEqual(.box("M"), tops[1])
        XCTAssertEqual(.box("Z"), tops[2])
    }

    func testPartOne() {
        let day = DayFive2022()
        let answer = day.partOne(input: sampleInput)
        XCTAssertEqual("CMZ", answer as! String)
    }

    func testGetTopBoxes() {
        let map = SupplyCrateMap.parse(sampleInput)

        let boxes = map.getTop(1, in: 0)
        XCTAssertEqual(1, boxes.count)
        XCTAssertEqual(Coordinate(x: 1, y: 0), boxes[0])

        let moreBoxes = map.getTop(2, in: 0)
        XCTAssertEqual(2, moreBoxes.count)
        XCTAssertEqual(Coordinate(x: 2, y: 0), moreBoxes.last)

        let mostBoxes = map.getTop(3, in: 0)
        XCTAssertEqual(2, mostBoxes.count)
        XCTAssertEqual(Coordinate(x: 2, y: 0), mostBoxes.last)

        XCTAssertEqual(3, map.getTop(4, in: 1).count)
        XCTAssertEqual(1, map.getTop(1, in: 2).count)
    }

    func testPartTwo() {
        let day = DayFive2022()
        let answer = day.partTwo(input: sampleInput)
        XCTAssertEqual("MCD", answer as! String)
    }
}
