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
        let factory = NanoFactory(input: testInput1)
        let hash = factory.reactions
        XCTAssertEqual(7, hash.keys.count)

        let fuel = hash["FUEL"]
        XCTAssertEqual(1, fuel?.quantity)
        XCTAssertEqual(3, fuel?.inputs.count)

        let ab = hash["AB"]
        XCTAssertEqual(1, ab?.quantity)
        XCTAssertEqual(2, ab?.inputs.count)
    }

    func testGatheringLoop() {
        var factory = NanoFactory(input: testInput1)
        factory.prime()
        factory.process()
        var reqs = factory.requirements
        XCTAssertEqual(3, reqs.count)
        XCTAssertEqual(2, reqs["AB"])
        XCTAssertEqual(3, reqs["BC"])
        XCTAssertEqual(4, reqs["CA"])

        factory = NanoFactory(input: testInput1)
        factory.prime(count: 2)
        factory.process()
        reqs = factory.requirements
        XCTAssertEqual(3, reqs.count)
        XCTAssertEqual(4, reqs["AB"])
        XCTAssertEqual(6, reqs["BC"])
        XCTAssertEqual(8, reqs["CA"])

        // start again
        factory = NanoFactory(input: testInput1)
        factory.prime()
        factory.process()
        // second loop
        factory.process()
        reqs = factory.requirements
        XCTAssertEqual(3, reqs.count)
        XCTAssertEqual(10, reqs["A"])
        XCTAssertEqual(23, reqs["B"])
        XCTAssertEqual(37, reqs["C"])
        // third loop
        factory.process()
        reqs = factory.requirements
        XCTAssertEqual(1, reqs.count)
        XCTAssertEqual(165, reqs["ORE"])
    }

    func testPartOne() {
        let day = DayFourteen()
        var result: Any

        result = day.partOne(input: testInput1)
        XCTAssertEqual(165, result as? Int)

        result = day.partOne(input: testInput2)
        XCTAssertEqual(13312, result as? Int)

        result = day.partOne(input: testInput3)
        XCTAssertEqual(180697, result as? Int)
    }

    func testPartOneAnswer() {
        let day = DayFourteen()
        let answer = day.run(part: 1) as! Int
        XCTAssertEqual(374457, answer)
    }

    func testPartTwoAnswer() {
        XCTAssert(true)
//        let day = DayFourteen()
//        let answer = day.run(part: 2) as! Int
//        XCTAssertEqual(416, answer)
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
