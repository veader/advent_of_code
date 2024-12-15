//
//  Day13_2024Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/13/24.
//

import Testing

struct Day13_2024Tests {
    let sampleData = """
        Button A: X+94, Y+34
        Button B: X+22, Y+67
        Prize: X=8400, Y=5400

        Button A: X+26, Y+66
        Button B: X+67, Y+21
        Prize: X=12748, Y=12176

        Button A: X+17, Y+86
        Button B: X+84, Y+37
        Prize: X=7870, Y=6450

        Button A: X+69, Y+23
        Button B: X+27, Y+71
        Prize: X=18641, Y=10279
        """

    let sampleWinnableMachine = """
        Button A: X+94, Y+34
        Button B: X+22, Y+67
        Prize: X=8400, Y=5400
        """

    let day = Day13_2024()

    @Test func testParsingClawMachines() async throws {
        let machines = day.parse(sampleData)
        #expect(machines.count == 4)

        let m1 = try #require(machines[0])
        #expect(m1.buttonA.x == 94)
        #expect(m1.buttonA.y == 34)
        #expect(m1.buttonB.x == 22)
        #expect(m1.buttonB.y == 67)
        #expect(m1.prize.x == 8400)
        #expect(m1.prize.y == 5400)
    }

    @Test func testPlayingWinableMachine() async throws {
        let machines = day.parse(sampleWinnableMachine)
        let tokens = day.play(machines: machines)
        #expect(tokens == 280)
    }

    @Test func testPlayingWithMachines() async throws {
        let machines = day.parse(sampleData)
        let tokens = day.play(machines: machines)
        #expect(tokens == 480)
    }

    @Test func testPartOneWithSampleData() async throws {
        let cost1 = try #require(day.partOne(input: sampleData) as? Int)
        #expect(cost1 == 480)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 26810)
    }
}
