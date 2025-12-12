//
//  DayEleven2025.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/12/25.
//

import Testing

struct DayEleven2025 {
    let day = Day11_2025()
    let sampleInput = """
        aaa: you hhh
        you: bbb ccc
        bbb: ddd eee
        ccc: ddd eee fff
        ddd: ggg
        eee: out
        fff: out
        ggg: out
        hhh: ccc fff iii
        iii: out
        """

    @Test func testParsingGraph() async throws {
        let graph = day.parse(sampleInput)
        #expect(graph.keys.count == 10)
        #expect(graph["aaa"] == ["you", "hhh"])
        #expect(graph["fff"] == ["out"])
    }

    @Test func testGraphDFSearch() async throws {
        let graph = day.parse(sampleInput)
        // where we'll store our answers
        var allPaths = Set<[String]>()
        day.searchForAllPaths(graph: graph, node: "you", path: [], allPaths: &allPaths)
        #expect(allPaths.count == 5)
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer = try #require(day.partOne(input: sampleInput) as? Int)
        #expect(answer == 5)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 791)
    }

}
