//
//  Day5_2023Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/5/23.
//

import XCTest

final class Day5_2023Tests: XCTestCase {

    let sampleInput = """
        seeds: 79 14 55 13

        seed-to-soil map:
        50 98 2
        52 50 48

        soil-to-fertilizer map:
        0 15 37
        37 52 2
        39 0 15

        fertilizer-to-water map:
        49 53 8
        0 11 42
        42 0 7
        57 7 4

        water-to-light map:
        88 18 7
        18 25 70

        light-to-temperature map:
        45 77 23
        81 45 19
        68 64 13

        temperature-to-humidity map:
        0 69 1
        1 0 69

        humidity-to-location map:
        60 56 37
        56 93 4
        """

    func testMapRangeParsing() throws {
        let goodMap = try XCTUnwrap(Almanac.MapRange.parse("1 2 3"))
        XCTAssertEqual(goodMap.destination, 1)
        XCTAssertEqual(goodMap.source, 2)
        XCTAssertEqual(goodMap.size, 3)

        let badMap = Almanac.MapRange.parse("foo bar 1")
        XCTAssertNil(badMap)
    }

    func testMapRangeContains() throws {
        let map = try XCTUnwrap(Almanac.MapRange.parse("1 2 3"))
        XCTAssertTrue(map.contains(2))
        XCTAssertTrue(map.contains(3))
        XCTAssertTrue(map.contains(4))

        XCTAssertFalse(map.contains(1))
        XCTAssertFalse(map.contains(5))
    }

    func testMapRangeMapping() throws {
        var map = try XCTUnwrap(Almanac.MapRange.parse("50 98 2"))
        XCTAssertEqual(map.map(97), 97)
        XCTAssertEqual(map.map(98), 50)
        XCTAssertEqual(map.map(99), 51)
        XCTAssertEqual(map.map(100), 100)

        map = try XCTUnwrap(Almanac.MapRange.parse("52 50 48"))
        XCTAssertEqual(map.map(49), 49)
        XCTAssertEqual(map.map(50), 52)
        XCTAssertEqual(map.map(51), 53)
        XCTAssertEqual(map.map(96), 98)
    }

    func testMappingMapping() throws {
        let range1 = try XCTUnwrap(Almanac.MapRange.parse("50 98 2"))
        let range2 = try XCTUnwrap(Almanac.MapRange.parse("52 50 48"))
        let map = Almanac.Mapping(source: .seed, destination: .soil, ranges: [range1, range2])

        XCTAssertEqual(map.map(1), 1)
        // ...
        XCTAssertEqual(map.map(48), 48)
        XCTAssertEqual(map.map(49), 49)
        XCTAssertEqual(map.map(50), 52)
        XCTAssertEqual(map.map(51), 53)
        // ...
        XCTAssertEqual(map.map(96), 98)
        XCTAssertEqual(map.map(97), 99)
        XCTAssertEqual(map.map(98), 50)
        XCTAssertEqual(map.map(99), 51)
        XCTAssertEqual(map.map(100), 100)
        // ...
    }

    func testAlmanacMapping() throws {
        let almanac = Almanac.parse(sampleInput)
        XCTAssertEqual(almanac.location(of: 79), 82)
        XCTAssertEqual(almanac.location(of: 14), 43)
        XCTAssertEqual(almanac.location(of: 55), 86)
        XCTAssertEqual(almanac.location(of: 13), 35)
    }

    func testAlmanacParsing() throws {
        let almanac = Almanac.parse(sampleInput)
        XCTAssertEqual(4, almanac.seeds.count)
        XCTAssertEqual(7, almanac.mappings.count)

        var mapping = try XCTUnwrap(almanac.map(for: .fertilizer))
        XCTAssertEqual(mapping.ranges.count, 4)

        mapping = try XCTUnwrap(almanac.map(for: .water))
        XCTAssertEqual(mapping.ranges.count, 2)
    }

    func testPart1() async throws {
        let answer = await Day5_2023().run(part: 1, sampleInput)
        XCTAssertEqual(35, answer as? Int)
    }

    func testPart1Answer() async throws {
        let answer = await Day5_2023().run(part: 1)
        XCTAssertEqual(240320250, answer as? Int)
    }

    func testBruteForce() throws {
        let almanac = Almanac.parse(sampleInput)
        almanac.mergeMaps()
    }
}
