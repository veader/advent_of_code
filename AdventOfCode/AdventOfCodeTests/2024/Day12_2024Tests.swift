//
//  Day12_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/12/24.
//

import Testing

struct Day12_2024Tests {
    let sampleData1 = """
        AAAA
        BBCD
        BBCC
        EEEC
        """

    let sampleData2 = """
        OOOOO
        OXOXO
        OOOOO
        OXOXO
        OOOOO
        """

    let sampleData3 = """
        RRRRIICCFF
        RRRRIICCCF
        VVRRRCCFFF
        VVRCCCJFFF
        VVVVCJJCFE
        VVIVCCJJEE
        VVIIICJJEE
        MIIIIIJJEE
        MIIISIJEEE
        MMMISSJEEE
        """

    let day = Day12_2024()

    @Test func testParsing() async throws {
        let garden1 = day.parse(sampleData1)
        #expect(garden1.plants.keys.count == 5)
        #expect(garden1.plants["A"]?.count == 4)
        #expect(garden1.plants["B"]?.count == 4)
        #expect(garden1.plants["C"]?.count == 4)
        #expect(garden1.plants["D"]?.count == 1)
        #expect(garden1.plants["E"]?.count == 3)

        let garden2 = day.parse(sampleData2)
        #expect(garden2.plants.keys.count == 2)
        #expect(garden2.plants["O"]?.count == 21)
        #expect(garden2.plants["X"]?.count == 4)
    }

    @Test func testFindingRegions() async throws {
        let garden = day.parse(sampleData1)

        let regionA = garden.findRegionsFor(plant: "A")
        #expect(regionA.count == 1)
        #expect(regionA.first?.count == 4)

        let regionB = garden.findRegionsFor(plant: "B")
        #expect(regionB.count == 1)
        #expect(regionB.first?.count == 4)

        let regionC = garden.findRegionsFor(plant: "C")
        #expect(regionC.count == 1)
        #expect(regionC.first?.count == 4)

        let regionD = garden.findRegionsFor(plant: "D")
        #expect(regionD.count == 1)
        #expect(regionD.first?.count == 1)

        let regionE = garden.findRegionsFor(plant: "E")
        #expect(regionE.count == 1)
        #expect(regionE.first?.count == 3)
    }

    @Test func testFindingRegionsWithHoles() async throws {
        let garden = day.parse(sampleData2)

        let regionO = garden.findRegionsFor(plant: "O")
        #expect(regionO.count == 1)
        #expect(regionO.first?.count == 21)

        let regionX = garden.findRegionsFor(plant: "X")
        #expect(regionX.count == 4)
    }

    @Test func testCalculatingRegionCost() async throws {
        let garden = day.parse(sampleData1)

        let regionA = garden.findRegionsFor(plant: "A")
        let costA = garden.calculateCostFor(region: regionA.first!)
        #expect(costA == 40)

        let regionB = garden.findRegionsFor(plant: "B")
        let costB = garden.calculateCostFor(region: regionB.first!)
        #expect(costB == 32)

        let regionC = garden.findRegionsFor(plant: "C")
        let costC = garden.calculateCostFor(region: regionC.first!)
        #expect(costC == 40)

        let regionD = garden.findRegionsFor(plant: "D")
        let costD = garden.calculateCostFor(region: regionD.first!)
        #expect(costD == 4)

        let regionE = garden.findRegionsFor(plant: "E")
        let costE = garden.calculateCostFor(region: regionE.first!)
        #expect(costE == 24)
    }

    @Test func testCalculatingRegionCostsWithHoles() async throws {
        let garden = day.parse(sampleData2)

        let regionO = garden.findRegionsFor(plant: "O")
        let costO = garden.calculateCostFor(region: regionO.first!)
        #expect(costO == 756)
    }

    @Test func testPartOneWithSampleData() async throws {
        let cost1 = try #require(day.partOne(input: sampleData1) as? Int)
        #expect(cost1 == 140)

        let cost2 = try #require(day.partOne(input: sampleData2) as? Int)
        #expect(cost2 == 772)

        let cost3 = try #require(day.partOne(input: sampleData3) as? Int)
        #expect(cost3 == 1930)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 1533024)
    }
}
