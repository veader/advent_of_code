//
//  Day18_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/19/24.
//

import Testing

struct Day19_2024Tests {
    let sampleData = """
        r, wr, b, g, bwu, rb, gb, br

        brwrr
        bggr
        gbbr
        rrbgbr
        ubwu
        bwurrg
        brgr
        bbrgwb
        """

    let day = Day19_2024()

    @Test func testParsingOsenPaterns() async throws {
        let osen = day.parse(sampleData)
        #expect(osen.patterns.count == 8)
        #expect(osen.longestPattern == 3)
        #expect(osen.designs.count == 8)
        #expect(osen.designs.first == "brwrr")
        #expect(osen.designs.last == "bbrgwb")
    }

    @Test func testDesignSolvingThirdTake() async throws {
        let osen = day.parse(sampleData)
        var answer = osen.hasSolution(design: "brwrr")
        #expect(answer == true)

        answer = osen.hasSolution(design: "bggr")
        #expect(answer == true)

        answer = osen.hasSolution(design: "gbbr")
        #expect(answer == true)

        answer = osen.hasSolution(design: "rrbgbr")
        #expect(answer == true)

        answer = osen.hasSolution(design: "bwurrg")
        #expect(answer == true)

        answer = osen.hasSolution(design: "brgr")
        #expect(answer == true)

        answer = osen.hasSolution(design: "ubwu")
        #expect(answer == false)

        answer = osen.hasSolution(design: "bbrgwb")
        #expect(answer == false)
    }

    @Test func testDesignSolvingSecondTake() async throws {
        let osen = day.parse(sampleData)
        var answer = await osen.solutionSearch(design: "brwrr")
        #expect(answer.count == 2)
        #expect(answer.contains(["br", "wr", "r"]))

        answer = await osen.solutionSearch(design: "bggr")
        #expect(answer.count == 1)
        #expect(answer == [["b", "g", "g", "r"]])

        answer = await osen.solutionSearch(design: "gbbr")
        #expect(answer.count == 4)
        #expect(answer.contains(["gb", "br"]))

        answer = await osen.solutionSearch(design: "rrbgbr")
        #expect(answer.count == 6)
        #expect(answer.contains(["r", "rb", "gb", "r"]))

        answer = await osen.solutionSearch(design: "bwurrg")
        #expect(answer.count == 1)
        #expect(answer == [["bwu", "r", "r", "g"]])

        answer = await osen.solutionSearch(design: "brgr")
        #expect(answer.count == 2)
        #expect(answer.contains(["br", "g", "r"]))

        answer = await osen.solutionSearch(design: "ubwu")
        #expect(answer.count == 0)

        answer = await osen.solutionSearch(design: "bbrgwb")
        #expect(answer.count == 0)
    }

    @Test func testDesignSolutionsFirstTake() async throws {
        let osen = day.parse(sampleData)
        var answer = try #require(osen.solve(design: "brwrr"))
        #expect(answer == ["br", "wr", "r"])

        answer = try #require(osen.solve(design: "bggr"))
        #expect(answer == ["b", "g", "g", "r"])

        answer = try #require(osen.solve(design: "gbbr"))
        #expect(answer == ["gb", "br"])

        answer = try #require(osen.solve(design: "rrbgbr"))
        #expect(answer == ["r", "rb", "gb", "r"]) // other solutions

        answer = try #require(osen.solve(design: "bwurrg"))
        #expect(answer == ["bwu", "r", "r", "g"]) // other solutions

        answer = try #require(osen.solve(design: "brgr"))
        #expect(answer == ["br", "g", "r"]) // other solutions

        #expect(osen.solve(design: "ubwu") == nil)
        #expect(osen.solve(design: "bbrgwb") == nil)
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer = try await #require(day.partOne(input: sampleData) as? Int)
        #expect(answer == 6)
    }

//    @Test func testPartOne() async throws {
//        let answer = try await #require(day.run(part: 1) as? Int)
//        #expect(answer == 283)
//
//        // 283 - too low
//    }

}
