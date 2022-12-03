//
//  DayThree2022Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/3/22.
//

import XCTest

final class DayThree2022Tests: XCTestCase {

    let sampleInput = """
        vJrwpWtwJgWrhcsFMMfFFhFp
        jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
        PmmdzqPrVvPwwTWBwg
        wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
        ttgJtRGJQctTZtZT
        CrZsJsPPZsGzwwsLwLmpwMDw
        """

    let misplacedItems = ["p", "L", "P", "v", "t", "s"]

    func testParsing() {
        let rucksacks = DayThree2022().parse(sampleInput)
        XCTAssertEqual(6, rucksacks.count)

        let first = rucksacks.first!
        XCTAssertEqual(12, first.compartment1.count)
        XCTAssertEqual(12, first.compartment2.count)

        let nearEnd = rucksacks[rucksacks.count - 2]
        XCTAssertEqual(8, nearEnd.compartment1.count)
        XCTAssertEqual(8, nearEnd.compartment2.count)
    }

    func testMisplacedItem() {
        let rucksacks = DayThree2022().parse(sampleInput)

        XCTAssertEqual(rucksacks.count, misplacedItems.count)

        for (idx, sack) in rucksacks.enumerated() {
            let item = sack.misplacedItem()
            XCTAssertNotNil(item)
            XCTAssertEqual(misplacedItems[idx], item)
        }
    }

    func testPriorities() {
        let day = DayThree2022()
        XCTAssertEqual(1, day.priority(of: "a"))
        XCTAssertEqual(26, day.priority(of: "z"))
        XCTAssertEqual(27, day.priority(of: "A"))
        XCTAssertEqual(52, day.priority(of: "Z"))
    }

    func testPartOne() {
        let day = DayThree2022()
        let answer = day.partOne(input: sampleInput)
        XCTAssertEqual(157, answer as! Int)
    }

    func testPartTwo() {
        let day = DayThree2022()
        let answer = day.partTwo(input: sampleInput)
        XCTAssertEqual(70, answer as! Int)
    }
}
