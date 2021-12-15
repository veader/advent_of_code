//
//  DayFourteen2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/14/21.
//

import XCTest

class DayFourteen2021Tests: XCTestCase {
    let sampleInput = """
        NNCB

        CH -> B
        HH -> N
        CB -> H
        NH -> C
        HB -> C
        HC -> B
        HN -> C
        NN -> C
        BH -> H
        NC -> B
        NB -> B
        BN -> B
        BB -> N
        BC -> B
        CC -> N
        CN -> C
        """

    func testInsertionPairParsing() {
        var pair = Polymer.InsertionPair.parse("CH -> B")
        XCTAssertNotNil(pair)
        XCTAssertEqual(["C", "H"], pair?.match)
        XCTAssertEqual("B", pair?.insertion)

        pair = Polymer.InsertionPair.parse("C -> B")
        XCTAssertNil(pair)

        pair = Polymer.InsertionPair.parse("CDG -> B")
        XCTAssertNil(pair)
    }

    func testPolymerParsing() {
        let polymer = Polymer.parse(sampleInput)
        XCTAssertEqual(["N", "N", "C", "B"], polymer.template)
        XCTAssertEqual(16, polymer.rules.count)
    }

    func testPolymerProcessRulesSingleRun() {
        let polymer = Polymer.parse(sampleInput)
        polymer.run(steps: 1, debugPrint: false)
        XCTAssertEqual("NCNBCHB".map(String.init), polymer.current)
        XCTAssertEqual(7, polymer.current.count)
    }

    func testPolymerRunTwoSteps() {
        let polymer = Polymer.parse(sampleInput)
        polymer.run(steps: 2, debugPrint: false)
        XCTAssertEqual("NBCCNBBBCBHCB".map(String.init), polymer.current)
        XCTAssertEqual(13, polymer.current.count)
    }

    func testPolymerRunFourSteps() {
        let polymer = Polymer.parse(sampleInput)
        polymer.run(steps: 4, debugPrint: false)
        XCTAssertEqual("NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB".map(String.init), polymer.current)
        XCTAssertEqual(49, polymer.current.count)
    }

    func testPolymerRunTenSteps() {
        let polymer = Polymer.parse(sampleInput)
        polymer.run(steps: 10, debugPrint: false)
        XCTAssertEqual(3073, polymer.current.count)
    }

    func testPolymerHistogram() {
        let polymer = Polymer.parse(sampleInput)
        polymer.run(steps: 10, debugPrint: false)
        XCTAssertEqual(3073, polymer.current.count)
        let gram = polymer.histogram()
        print(gram)
        XCTAssertEqual(1749, gram["B"])
        XCTAssertEqual(865, gram["N"])
        XCTAssertEqual(298, gram["C"])
        XCTAssertEqual(161, gram["H"])
    }

}
