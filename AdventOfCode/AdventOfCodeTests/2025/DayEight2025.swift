//
//  DayEight2025.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/8/25.
//

import Testing

struct DayEight2025 {

    let day = Day8_2025()
    let sampleInput = """
        162,817,812
        57,618,57
        906,360,560
        592,479,940
        352,342,300
        466,668,158
        542,29,236
        431,825,988
        739,650,466
        52,470,668
        216,146,977
        819,987,18
        117,168,530
        805,96,715
        346,949,466
        970,615,88
        941,993,340
        862,61,35
        984,92,344
        425,690,689
        """

    @Test func testParsingSampleInput() async throws {
        let coordinates = day.parse(sampleInput)
        #expect(coordinates.count == 20)
        #expect(coordinates.first == ThreeDCoordinate(x: 162, y: 817, z: 812))
        #expect(coordinates.last == ThreeDCoordinate(x: 425, y: 690, z: 689))
    }

    @Test func testCreating3DSpace() async throws {
        let coordinates = day.parse(sampleInput)
        let space = ThreeDSpace(coordinates: coordinates)
        #expect(space.coordinates.count == coordinates.count)
        #expect(space.distanceMap.count == 190)
    }

    @Test func testBuildingCurcuitsLimited() async throws {
        let coordinates = day.parse(sampleInput)
        let space = ThreeDSpace(coordinates: coordinates)

        let circuits = space.buildConnections(10)
        #expect(circuits.count == 4) // should be 4
    }

    @Test func testBuildingCurcuits() async throws {
        let coordinates = day.parse(sampleInput)
        let space = ThreeDSpace(coordinates: coordinates)

        let circuits = space.buildConnections()
        #expect(circuits.count == 1) // there can be only one!
    }

    @Test func testScoringTopThreeCircuits() async throws {
        let coordinates = day.parse(sampleInput)
        let space = ThreeDSpace(coordinates: coordinates)
        let circuits = space.buildConnections(10)
        let score = space.topThreeScore(circuits: circuits)
        #expect(score == 40)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 121770)
    }
}
