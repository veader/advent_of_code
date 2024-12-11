//
//  Day10_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/10/24.
//

import Testing

struct Day10_2024Tests {

    let sampleData1 = """
        0123
        1234
        8765
        9876
        """

    let sampleData2 = """
        ..90..9
        ...1.98
        ...2..7
        6543456
        765.987
        876....
        987....
        """

    let sampleData3 = """
        10..9..
        2...8..
        3...7..
        4567654
        ...8..3
        ...9..2
        .....01
        """

    let sampleData4 = """
        89010123
        78121874
        87430965
        96549874
        45678903
        32019012
        01329801
        10456732
        """

    let day = Day10_2024()

    @Test func testTopoMapParsing() async throws {
        let map1 = day.parse(sampleData1)
        #expect(map1.grid.width == 4)
        #expect(map1.grid.height == 4)
        #expect(map1.startingPoints.count == 1)
        #expect(map1.startingPoints.first == Coordinate(x: 0, y: 0))

        let map2 = day.parse(sampleData2)
        #expect(map2.grid.width == 7)
        #expect(map2.grid.height == 7)
        #expect(map2.startingPoints.count == 1)
        #expect(map2.startingPoints.first == Coordinate(x: 3, y: 0))

        let map3 = day.parse(sampleData3)
        #expect(map3.grid.width == 7)
        #expect(map3.grid.height == 7)
        #expect(map3.startingPoints.count == 2)

        let map4 = day.parse(sampleData4)
        #expect(map4.grid.width == 8)
        #expect(map4.grid.height == 8)
        #expect(map4.startingPoints.count == 9)
    }

    @Test func testHikingRouteDetection() async throws {
        let map = day.parse(sampleData1)
        let routes = await map.findRoutes()
        #expect(routes.count == 16) // is this right?
        let lastCoordinates = routes.compactMap(\.last).unique()
        #expect(lastCoordinates.count == 1)
        #expect(lastCoordinates.first == Coordinate(x: 0, y: 3))

        let map2 = day.parse(sampleData2)
        let routes2 = await map2.findRoutes()
        #expect(routes2.count == 13) // is this right?
        let last2 = routes2.compactMap(\.last).unique()
        #expect(last2.count == 4) // only one of the 9's isn't accessible

        let map4 = day.parse(sampleData4)
        let routes4 = await map4.findRoutes()
        #expect(routes4.count == 81) // is this right?
        let last4 = routes4.compactMap(\.last).unique()
        #expect(last4.count == 7) // all of the 9's are accessible
    }

    @Test func testTrailheadScoring() async throws {
        let map1 = day.parse(sampleData1)
        let scores1 = await map1.scoreTrailheads()
        #expect(scores1.count == 1)
        #expect(scores1.first?.value == 1)

        let map2 = day.parse(sampleData2)
        let scores2 = await map2.scoreTrailheads()
        #expect(scores2.count == 1)
        #expect(scores2.first?.value == 4)

        let map3 = day.parse(sampleData3)
        let scores3 = await map3.scoreTrailheads()
        #expect(scores3.count == 2)
        #expect(scores3.values.sorted() == [1,2])

        let map4 = day.parse(sampleData4)
        let scores4 = await map4.scoreTrailheads()
        #expect(scores4.count == 9)
        #expect(scores4.values.sorted() == [1,3,3,3,5,5,5,5,6])
    }


    @Test func testPartOneWithSampleData() async throws {
        let answer = try await #require(day.partOne(input: sampleData4) as? Int)
        #expect(answer == 36)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 593)
    }
}
