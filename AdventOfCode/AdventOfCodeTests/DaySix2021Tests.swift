//
//  DaySix2021Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/6/21.
//

import XCTest

class DaySix2021Tests: XCTestCase {

    let sampleInput = "3,4,3,1,2"

    func testShortDayModeling() {
        let day = DaySix2021()
        let initialFish = day.parse(sampleInput)
        let finalFish = day.model(days: 2, fish: initialFish)
        XCTAssertEqual(6, finalFish)

        let otherFish = day.betterModeling(days: 2, fish: initialFish)
        XCTAssertEqual(6, otherFish)
    }

    func testMediumDayModeling() {
        let day = DaySix2021()
        let initialFish = day.parse(sampleInput)
        let finalFish = day.model(days: 18, fish: initialFish)
        XCTAssertEqual(26, finalFish)

        let otherFish = day.betterModeling(days: 18, fish: initialFish)
        XCTAssertEqual(26, otherFish)
    }

    func testLongDayModeling() {
        let day = DaySix2021()
        let initialFish = day.parse(sampleInput)
        let finalFish = day.model(days: 80, fish: initialFish)
        XCTAssertEqual(5934, finalFish)

        let otherFish = day.betterModeling(days: 80, fish: initialFish)
        XCTAssertEqual(5934, otherFish)
    }

    func testExtraLongDayModeling() {
        let day = DaySix2021()
        let initialFish = day.parse(sampleInput)
        let finalFishCount = day.betterModeling(days: 256, fish: initialFish)
        XCTAssertEqual(26984457539, finalFishCount)
    }
}
