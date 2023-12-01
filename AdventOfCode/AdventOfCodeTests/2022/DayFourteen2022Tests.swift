//
//  DayFourteen2022Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/16/22.
//

import XCTest

final class DayFourteen2022Tests: XCTestCase {

    let sampleInput = """
        498,4 -> 498,6 -> 496,6
        503,4 -> 502,4 -> 502,9 -> 494,9
        """
    func testSimpleParsing() {
        let paths = SandSim.parse(sampleInput)
        XCTAssertEqual(2, paths.count)
        print(paths)
    }

    func testSandSimRockFinding() {
        let paths = SandSim.parse(sampleInput)
        let sim = SandSim(paths: paths)
        XCTAssertEqual(2, sim.paths.count)
        XCTAssertEqual(20, sim.rocks.count)

//        sim.printScan()
    }

    func testSandSimulation() {
        let paths = SandSim.parse(sampleInput)
        let sim = SandSim(paths: paths)
        var answer = sim.run(rounds: 24)
        XCTAssertEqual(-1, answer) // 24 is fine
//        sim.printScan()

        answer = sim.run(rounds: 1)
        XCTAssertEqual(0, answer) // 25 is into the void
//        sim.printScan()
    }

    func testPartOne() {
        let answer = DayFourteen2022().partOne(input: sampleInput)
        XCTAssertEqual(24, answer as! Int)
    }

    func testSimWithFloor() {
        let paths = SandSim.parse(sampleInput)
        let sim = SandSim(paths: paths)
        let answer = sim.run(floor: true, rounds: 95)
        XCTAssertEqual(93, answer)
        sim.printScan(floor: true)
    }
}
