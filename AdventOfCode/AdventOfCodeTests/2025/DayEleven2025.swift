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

    let sampleInput2 = """
        svr: aaa bbb
        aaa: fft
        fft: ccc
        bbb: tty
        tty: ccc
        ccc: ddd eee
        ddd: hub
        hub: fff
        eee: dac
        dac: fff
        fff: ggg hhh
        ggg: out
        hhh: out
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

    @Test func testGraphSearchPartTwo() async throws {
        let graph = day.parse(sampleInput2)
        // where we'll store our answers
        var allPaths = Set<[String]>()
        day.searchForAllPaths(graph: graph, node: "svr", path: [], allPaths: &allPaths, part2: true)
        #expect(allPaths.count == 2)
    }

    @Test func testPartTwoWithSampleData() async throws {
        let answer = try #require(day.partTwo(input: sampleInput2) as? Int)
        #expect(answer == 2)
    }

//    @Test func testPartTwo() async throws {
//        let answer = try await #require(day.run(part: 2) as? Int)
//        #expect(answer == 791)
//    }

}
