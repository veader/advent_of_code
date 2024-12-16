//
//  Day14_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/15/24.
//

import Testing

struct Day14_2024Tests {
    let sampleData = """
        p=0,4 v=3,-3
        p=6,3 v=-1,-3
        p=10,3 v=-1,2
        p=2,0 v=2,-1
        p=0,0 v=1,3
        p=3,0 v=-2,-2
        p=7,6 v=-1,-3
        p=3,0 v=-1,-2
        p=9,3 v=2,3
        p=7,3 v=-1,2
        p=2,4 v=2,-3
        p=9,5 v=-3,-3
        """

    let day = Day14_2024()

    @Test func testParsing() async throws {
        let bots = day.parse(sampleData)
        #expect(bots.count == 12)

        let bot1 = try #require(bots.first)
        #expect(bot1.position == Coordinate(x: 0, y: 4))
        #expect(bot1.velocity.x == 3)
        #expect(bot1.velocity.y == -3)

        let bot2 = try #require(bots.last)
        #expect(bot2.position == Coordinate(x: 9, y: 5))
        #expect(bot2.velocity.x == -3)
        #expect(bot2.velocity.y == -3)
    }

    @Test func testBotMovement() async throws {
        let bot = try #require(BathroomBot(input: "p=2,4 v=2,-3"))
        let bathroom = BathroomSimulator(bots: [bot], width: 11, height: 7)
        #expect(bathroom.positions[bot] == Coordinate(x: 2, y: 4))

        await bathroom.tick()
        #expect(bathroom.positions[bot] == Coordinate(x: 4, y: 1))

        await bathroom.tick()
        #expect(bathroom.positions[bot] == Coordinate(x: 6, y: 5))

        await bathroom.tick()
        #expect(bathroom.positions[bot] == Coordinate(x: 8, y: 2))

        await bathroom.tick()
        #expect(bathroom.positions[bot] == Coordinate(x: 10, y: 6))

        await bathroom.tick()
        #expect(bathroom.positions[bot] == Coordinate(x: 1, y: 3))
    }

    @Test func testBotMovement100() async throws {
        let bots = day.parse(sampleData)
        let bathroom = BathroomSimulator(bots: bots, width: 11, height: 7)

        await bathroom.tick(seconds: 100)
        #expect(bathroom.bots(at: Coordinate(x: 6, y: 0)) == 2)
        #expect(bathroom.bots(at: Coordinate(x: 9, y: 0)) == 1)
        #expect(bathroom.bots(at: Coordinate(x: 0, y: 2)) == 1)
        #expect(bathroom.bots(at: Coordinate(x: 0, y: 2)) == 1)
        #expect(bathroom.bots(at: Coordinate(x: 1, y: 3)) == 1)
        #expect(bathroom.bots(at: Coordinate(x: 2, y: 3)) == 1)
        #expect(bathroom.bots(at: Coordinate(x: 5, y: 4)) == 1)
        #expect(bathroom.bots(at: Coordinate(x: 3, y: 5)) == 1)
        #expect(bathroom.bots(at: Coordinate(x: 4, y: 5)) == 2)
        #expect(bathroom.bots(at: Coordinate(x: 1, y: 6)) == 1)
        #expect(bathroom.bots(at: Coordinate(x: 6, y: 6)) == 1)
    }

    @Test func testQuadrants() async throws {
        let bathroom = BathroomSimulator(bots: [], width: 11, height: 7)
        let quads = bathroom.quadrants()
        #expect(quads.count == 4)

        let topLeft = try #require(quads[0])
        #expect(topLeft.width == 0..<5)
        #expect(topLeft.height == 0..<3)

        let topRight = try #require(quads[1])
        #expect(topRight.width == 6..<11)
        #expect(topRight.height == 0..<3)

        let bottomLeft = try #require(quads[2])
        #expect(bottomLeft.width == 0..<5)
        #expect(bottomLeft.height == 4..<7)

        let bottomRight = try #require(quads[3])
        #expect(bottomRight.width == 6..<11)
        #expect(bottomRight.height == 4..<7)
    }

    @Test func testSafetyFactor() async throws {
        let bots = day.parse(sampleData)
        let bathroom = BathroomSimulator(bots: bots, width: 11, height: 7)

        await bathroom.tick(seconds: 100)
        #expect(bathroom.safetyFactor() == 12)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 219150360)
    }

//    @Test func testPartTwo() async throws {
//        let answer = try await #require(day.run(part: 2) as? Int)
//        #expect(answer == 1)
//    }

}
