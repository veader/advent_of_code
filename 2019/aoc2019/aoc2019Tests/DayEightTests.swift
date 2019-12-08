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
        var image: SpaceImage
        var data: [Int]

        data = DayEight().parse("123456789012")
        image = SpaceImage(width: 3, height: 2, data: data)
        XCTAssertEqual(2, image.layers.count)
        XCTAssertEqual(6, image.layers.first?.pixels.count)
    }

    func testLayerIndexingAndColor() {
        let data = DayEight().parse("0222112222120000")
        let image = SpaceImage(width: 2, height: 2, data: data)
        XCTAssertEqual(4, image.layers.count)

        var color: SpaceImage.Layer.PixelColor?

        // make sure we can't color outside the bounds
        XCTAssertNil(image.layers.first?.color(x: 0, y: 3))
        XCTAssertNil(image.layers.first?.color(x: 3, y: 0))
        XCTAssertNil(image.layers.first?.color(x: 3, y: 6))

        color = image.layers.first?.color(x: 0, y: 0)
        XCTAssertNotNil(color)
        XCTAssertEqual(.black, color)

        color = image.layers.first?.color(x: 1, y: 0)
        XCTAssertNotNil(color)
        XCTAssertEqual(.transparent, color)
    }

    func testImageColorAtPixel() {
        let data = DayEight().parse("0222112222120000")
        let image = SpaceImage(width: 2, height: 2, data: data)

        var color: SpaceImage.Layer.PixelColor?

        // make sure we can't color outside the bounds
        XCTAssertNil(image.color(x: 0, y: 7))
        XCTAssertNil(image.color(x: 7, y: 0))
        XCTAssertNil(image.color(x: 7, y: 7))

        color = image.color(x: 0, y: 0)
        XCTAssertEqual(.black, color)
        color = image.color(x: 1, y: 0)
        XCTAssertEqual(.white, color)
        color = image.color(x: 0, y: 1)
        XCTAssertEqual(.white, color)
        color = image.color(x: 1, y: 1)
        XCTAssertEqual(.black, color)
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
