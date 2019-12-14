//
//  DayFourteenTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/14/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DayFourteenTests: XCTestCase {

    func testReactionParsing() {
        let input = "12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ"
        let reaction = Reaction(input: input)
        XCTAssertEqual(9, reaction?.quantity)
        XCTAssertEqual("QDVJ", reaction?.output)
        XCTAssertEqual(3, reaction?.inputs.count)
        XCTAssertEqual(12, reaction?.inputs["HKGWZ"])
    }

    func testParsing() {
        let hash = DayFourteen().parse(testInput1)
        XCTAssertEqual(7, hash.keys.count)

        let fuel = hash["FUEL"]
        XCTAssertEqual(1, fuel?.quantity)
        XCTAssertEqual(3, fuel?.inputs.count)

        let ab = hash["AB"]
        XCTAssertEqual(1, ab?.quantity)
        XCTAssertEqual(2, ab?.inputs.count)
    }

    func testDivision() {
        let remainder = 23 % 3
        var answer = 23/3
        answer += (remainder == 0 ? 0 : 1)
        XCTAssertEqual(8, answer)
    }

    func testGatheringLoop() {
        let day = DayFourteen()
        let hash = day.parse(testInput1)
        var reqs = day.gatheringLoop(reactions: hash, requirements: ["FUEL": 1])
        XCTAssertEqual(3, reqs.count)
        XCTAssertEqual(2, reqs["AB"])
        XCTAssertEqual(3, reqs["BC"])
        XCTAssertEqual(4, reqs["CA"])

        reqs = day.gatheringLoop(reactions: hash, requirements: ["FUEL": 2])
        XCTAssertEqual(3, reqs.count)
        XCTAssertEqual(4, reqs["AB"])
        XCTAssertEqual(6, reqs["BC"])
        XCTAssertEqual(8, reqs["CA"])

        // start again
        reqs = day.gatheringLoop(reactions: hash, requirements: ["FUEL": 1])
        // second loop
        reqs = day.gatheringLoop(reactions: hash, requirements: reqs)
        XCTAssertEqual(3, reqs.count)
        XCTAssertEqual(10, reqs["A"])
        XCTAssertEqual(23, reqs["B"])
        XCTAssertEqual(37, reqs["C"])
        // third loop
        reqs = day.gatheringLoop(reactions: hash, requirements: reqs)
        XCTAssertEqual(1, reqs.count)
        XCTAssertEqual(165, reqs["ORE"])
    }

    func testPartOne() {
        let day = DayFourteen()
        var result: Any

//        result == day.partOne(input: testInput1)
//        XCTAssertEqual(165, result as? Int)

        result = day.partOne(input: testInput2)
        XCTAssertEqual(13312, result as? Int)

//        result = day.partOne(input: testInput3)
//        XCTAssertEqual(180697, result as? Int)
    }

    let testInput1 = """
                     9 ORE => 2 A
                     8 ORE => 3 B
                     7 ORE => 5 C
                     3 A, 4 B => 1 AB
                     5 B, 7 C => 1 BC
                     4 C, 1 A => 1 CA
                     2 AB, 3 BC, 4 CA => 1 FUEL
                     """

    let testInput2 = """
                     157 ORE => 5 NZVS
                     165 ORE => 6 DCFZ
                     44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
                     12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
                     179 ORE => 7 PSHF
                     177 ORE => 5 HKGWZ
                     7 DCFZ, 7 PSHF => 2 XJWVT
                     165 ORE => 2 GPVTF
                     3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT
                     """

    let testInput3 = """
                     2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG
                     17 NVRVD, 3 JNWZP => 8 VPVL
                     53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL
                     22 VJHF, 37 MNCFX => 5 FWMGM
                     139 ORE => 4 NVRVD
                     144 ORE => 7 JNWZP
                     5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC
                     5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV
                     145 ORE => 6 MNCFX
                     1 NVRVD => 8 CXFTF
                     1 VJHF, 6 MNCFX => 4 RFSQX
                     176 ORE => 6 VJHF
                     """
}
