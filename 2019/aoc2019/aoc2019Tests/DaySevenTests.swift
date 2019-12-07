//
//  DaySevenTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/7/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DaySevenTests: XCTestCase {
    func testAmpCircuit() {
        var circuit: AmpCircuit

        circuit = AmpCircuit(memory: [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0], sequence: [4,3,2,1,0])
        XCTAssertEqual(43210, circuit.process())

        circuit = AmpCircuit(memory: [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0], sequence: [0,1,2,3,4])
        XCTAssertEqual(54321, circuit.process())

        circuit = AmpCircuit(memory: [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0], sequence: [1,0,4,3,2])
        XCTAssertEqual(65210, circuit.process())
    }

    func testMutations() {
        let day = DaySeven()
        var mutations: [[Int]]

        mutations = day.mutations(of: [0,1])
        XCTAssertEqual(2, mutations.count)

        mutations = day.mutations(of: [0,1,2])
        XCTAssertEqual(6, mutations.count)

        mutations = day.mutations(of: [0,1,2,3])
        XCTAssertEqual(24, mutations.count)
    }

    func testPartOne() {
        let day = DaySeven()
        var answer: Any

        answer = day.partOne(input: "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0")
        XCTAssertEqual(43210, answer as? Int)

        answer = day.partOne(input: "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0")
        XCTAssertEqual(54321, answer as? Int)

        answer = day.partOne(input: "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0")
        XCTAssertEqual(65210, answer as? Int)
    }

    func testPartOneAnswer() {
        let day = DaySeven()
        let answer = day.run(part: 1) as! Int
        XCTAssertEqual(273814, answer)
    }

    func testPartTwoAnswer() {
        XCTAssert(true)
//        let day = DaySeven()
//        let answer = day.run(part: 2) as! Int
//        XCTAssertEqual(340, answer)
    }
}
