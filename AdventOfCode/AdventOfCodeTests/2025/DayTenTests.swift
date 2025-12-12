//
//  DayTenTests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/10/25.
//

import Testing

struct DayTenTests {
    let day = Day10_2025()
    let sampleInput = """
        [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
        [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
        [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
        """

    let singleMachine = "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}"

    @Test("Parsing Joltage Machines", arguments: [
        ("[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}", 4, 6),
        ("[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}", 5, 5),
        ("[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}", 6, 4)
    ])
    func testParsingJoltageMachine(input: String, lightCount: Int, buttonCount: Int) async throws {
        let machine = try #require(JoltageMachine(input))
        #expect(machine.lights.count == lightCount)
        #expect(machine.buttons.count == buttonCount)
    }

    @Test func testPressingButtons() async throws {
        let machine = try #require(JoltageMachine(singleMachine))
        #expect(machine.lightState == "....")

        machine.pressButton(0)
        #expect(machine.lightState == "...#")
        #expect(machine.presses == [0])
        machine.pressButton(0)
        #expect(machine.lightState == "....")
        #expect(machine.presses == [0,0])

        machine.pressButton(1)
        #expect(machine.lightState == ".#.#")
        #expect(machine.presses == [0,0,1])
        machine.pressButton(1)
        #expect(machine.lightState == "....")
        #expect(machine.presses == [0,0,1,1])

        machine.pressButton(2)
        #expect(machine.lightState == "..#.")
        machine.pressButton(2)
        #expect(machine.lightState == "....")

        machine.pressButton(1)
        print(machine.lightState)
        machine.pressButton(3)
        print(machine.lightState)
        machine.pressButton(5)
        print(machine.lightState)
        machine.pressButton(5)
        print(machine.lightState)
    }

    @Test func testShortestPathAlgo() async throws {
        let machine = try #require(JoltageMachine(singleMachine))

        let (count, _) = machine.findShortestPath()
        #expect(count == 2)
    }

    @Test func testPartOneWithSampleData() async throws {
        let answer = try #require(day.partOne(input: sampleInput) as? Int)
        #expect(answer == 7)
    }

    @Test func testPartOne() async throws {
        let answer = try await #require(day.run(part: 1) as? Int)
        #expect(answer == 452) // takes ~45 seconds
    }

    @Test func testShortestJoltagePath() async throws {
        let machine = try #require(JoltageMachine(singleMachine))
//        #expect(machine.joltageCorrect == false)
//        #expect(machine.joltageExceeded == false)

        let answer = machine.findJoltageShortestPath()
        #expect(answer == 10) // takes ~30 sec
    }

    @Test func testPartTwoWithSampleData() async throws {
        let answer = try #require(day.partTwo(input: sampleInput) as? Int)
        #expect(answer == 33)
    }


}
