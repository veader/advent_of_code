//
//  DayEleven2022Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/11/22.
//

import XCTest

final class DayEleven2022Tests: XCTestCase {

    let singleMonkey = """
        Monkey 0:
          Starting items: 79, 98
          Operation: new = old * 19
          Test: divisible by 23
            If true: throw to monkey 2
            If false: throw to monkey 3
        """
    let sampleInput = """
        Monkey 0:
          Starting items: 79, 98
          Operation: new = old * 19
          Test: divisible by 23
            If true: throw to monkey 2
            If false: throw to monkey 3

        Monkey 1:
          Starting items: 54, 65, 75, 74
          Operation: new = old + 6
          Test: divisible by 19
            If true: throw to monkey 2
            If false: throw to monkey 0

        Monkey 2:
          Starting items: 79, 60, 97
          Operation: new = old * old
          Test: divisible by 13
            If true: throw to monkey 1
            If false: throw to monkey 3

        Monkey 3:
          Starting items: 74
          Operation: new = old + 3
          Test: divisible by 17
            If true: throw to monkey 0
            If false: throw to monkey 1
        """

    func testSimpleParsing() {
        let monkeys = MonkeySim.parse(singleMonkey)
        XCTAssertEqual(1, monkeys.count)

        let monkey = monkeys.first!
        XCTAssertEqual(0, monkey.index)
        XCTAssertEqual([79, 98], monkey.items)

        XCTAssertEqual(.multiply, monkey.op)
        XCTAssertEqual(.digit(19), monkey.opInput)

        XCTAssertEqual(23, monkey.testValue)
        XCTAssertEqual(2, monkey.testTrueIndex)
        XCTAssertEqual(3, monkey.testFalseIndex)
    }

    func testParsing() {
        let monkeys = MonkeySim.parse(sampleInput)
        XCTAssertEqual(4, monkeys.count)
    }

    func testRunOnSingleMonkey() {
        let sim = MonkeySim(monkeys: MonkeySim.parse(sampleInput))
        XCTAssertEqual(4, sim.monkeys.count)

        let monkey = sim.monkeys.first!
        XCTAssertEqual(0, monkey.index)

        sim.handle(monkey: monkey)

        XCTAssertEqual(0, monkey.items.count) // removed all items
        XCTAssertEqual(3, sim.monkeys[3].items.count) // monkey 3 got both items
        XCTAssertEqual([74, 500, 620], sim.monkeys[3].items)
    }

    func testRunOneRound() {
        let sim = MonkeySim(monkeys: MonkeySim.parse(sampleInput))
        sim.run(rounds: 1)

        XCTAssertEqual(4, sim.monkeys[0].items.count)
        XCTAssertEqual(6, sim.monkeys[1].items.count)
        XCTAssertEqual(0, sim.monkeys[2].items.count)
        XCTAssertEqual(0, sim.monkeys[3].items.count)

        XCTAssertEqual([20, 23, 27, 26], sim.monkeys[0].items)
        XCTAssertEqual([2080, 25, 167, 207, 401, 1046], sim.monkeys[1].items)
    }

    func testInspectionCounts() {
        let sim = MonkeySim(monkeys: MonkeySim.parse(sampleInput))
        sim.run(rounds: 20)
        XCTAssertEqual(101, sim.monkeys[0].inspectionCount)
        XCTAssertEqual(95, sim.monkeys[1].inspectionCount)
        XCTAssertEqual(7, sim.monkeys[2].inspectionCount)
        XCTAssertEqual(105, sim.monkeys[3].inspectionCount)
    }

    func testPartOne() {
        let answer = DayEleven2022().partOne(input: sampleInput)
        XCTAssertEqual(10605, answer as! Int)
    }

    func xtestAThousandRoundsNoDivide() {
        let sim = MonkeySim(monkeys: MonkeySim.parse(sampleInput))
        sim.run(rounds: 1000, divide: false)
        // BOOM!
    }
}
