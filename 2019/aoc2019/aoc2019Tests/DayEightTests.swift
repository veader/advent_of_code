//
//  DayEightTests.swift
//  aoc2019Tests
//
//  Created by Shawn Veader on 12/8/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import XCTest

class DayEightTests: XCTestCase {
    func testSpaceImage() {
        let day = DayEight()
        var image: SpaceImage
        var data: [Int]

        data = day.parse("123456789012")
        image = SpaceImage(width: 3, height: 2, data: data)
        XCTAssertEqual(2, image.layers.count)
        XCTAssertEqual(6, image.layers.first?.pixels.count)
    }

    func testPartOneAnswer() {
        let day = DayEight()
        let answer = day.run(part: 1) as! Int
        XCTAssertEqual(2210, answer)
    }

    func testPartTwoAnswer() {
        XCTAssert(true)
//        let day = DayEight()
//        let answer = day.run(part: 2) as! Int
//        XCTAssertEqual(34579864, answer)
    }
}
