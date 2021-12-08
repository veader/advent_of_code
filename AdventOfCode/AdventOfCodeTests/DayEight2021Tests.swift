//
//  DayEight2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/8/21.
//

import XCTest

class DayEight2021Tests: XCTestCase {

    func testSegmentedDisplayParsing() {
        var segment = SegmentedDisplay.parse("be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe")
        XCTAssertNotNil(segment)
        XCTAssertEqual(10, segment!.patterns.count)
        XCTAssertEqual(4, segment!.outputValues.count)

        segment = SegmentedDisplay.parse("dg debg edgfc afbgcd efdbgc gdc bfdceag bfdec febcad gfaec | dcg bdaegfc egbd dcgfe")
        XCTAssertNotNil(segment)
        XCTAssertEqual(10, segment!.patterns.count)
        XCTAssertEqual(4, segment!.outputValues.count)

        // ---- failing cases...
        // does not have a pipe
        segment = SegmentedDisplay.parse("dg debg edgfc afbgcd efdbgc gdc bfdceag bfdec febcad gfaec dcg bdaegfc egbd gcbe")
        XCTAssertNil(segment)

        // does not have 4 output values
        segment = SegmentedDisplay.parse("dg debg edgfc afbgcd efdbgc gdc bfdceag bfdec febcad gfaec | dcg bdaegfc egbd")
        XCTAssertNil(segment)
    }

    let sampleInput = """
        be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
        edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
        fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
        fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
        aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
        fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
        dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
        bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
        egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
        gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
        """

    func testCountingEasyValues() {
        let day = DayEight2021()
        let segments = day.parse(sampleInput)
        XCTAssertEqual(10, segments.count)
        let easyCount = day.countEasyValues(displays: segments)
        XCTAssertEqual(26, easyCount)
    }

    func testDisplayMapBuilding() {
        let segment = SegmentedDisplay.parse("be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe")
        let map = SegmentedDisplay.buildMap(patterns: segment!.patterns)
        XCTAssertEqual(1, map["be"])
        XCTAssertEqual(7, map["bde"])
        XCTAssertEqual(4, map["bceg"])
        XCTAssertEqual(8, map["abcdefg"])
    }

    func testSegmentedDisplayFinalOutput() {
        let segment = SegmentedDisplay.parse("acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf")
        let final = segment?.finalOutput
        XCTAssertEqual(5353, final)
    }
}
