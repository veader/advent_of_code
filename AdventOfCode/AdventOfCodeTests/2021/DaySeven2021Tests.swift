//
//  DaySeven2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/7/21.
//

import XCTest

class DaySeven2021Tests: XCTestCase {

    let sampleInput = "16,1,2,0,4,2,7,1,2,14"

    func testModeCalculation() {
        let day = DaySeven2021()
        let nums = day.parse(sampleInput)
        let mode = day.mode(of: nums)
        XCTAssertEqual(2, mode)
    }

    func testMedianCalculation() {
        let day = DaySeven2021()
        let nums = day.parse(sampleInput)
        let median = day.median(of: nums)
        XCTAssertEqual(2, median)
    }

    func testMeanCalculation() {
        let day = DaySeven2021()
        let nums = day.parse(sampleInput)
        let mean = day.mean(of: nums)
        XCTAssertEqual(5, mean)

        let mean2 = day.mean(of: [1,2,7])
        XCTAssertEqual(3, mean2)
    }

    func testCostCalculation() {
        let day = DaySeven2021()
        let nums = day.parse(sampleInput)
        let cost = day.calculcateCost(destination: 2, positions: nums)
        XCTAssertEqual(37, cost)
    }

    func testCostCalculationIncreasingCost() {
        let day = DaySeven2021()
        let nums = day.parse(sampleInput)
        let cost = day.calculcateCost(destination: 5, positions: nums, constantCost: false)
        XCTAssertEqual(168, cost)
    }
}
