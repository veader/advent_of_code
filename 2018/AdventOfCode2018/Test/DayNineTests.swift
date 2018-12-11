//
//  DayNineTests.swift
//  Test
//
//  Created by Shawn Veader on 12/9/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import XCTest

class DayNineTests: XCTestCase {

    func testCircleInsert() {
        let circle = MarbleCircle()
        circle.insert(marble: 1)
        circle.insert(marble: 2)
        circle.insert(marble: 3)
        XCTAssertEqual([0, 2, 1, 3], circle.array)
        XCTAssertEqual(4, circle.count)

        circle.insert(marble: 4)
        circle.insert(marble: 5)
        XCTAssertEqual([0, 4, 2, 5, 1, 3], circle.array)
        XCTAssertEqual(6, circle.count)
    }

    func testCircleRemove() {
        let circle = MarbleCircle()
        circle.insert(marble: 1)
        circle.insert(marble: 2)
        circle.insert(marble: 3)
        circle.insert(marble: 4)
        circle.insert(marble: 5)
        circle.insert(marble: 6)
        circle.insert(marble: 7)
        circle.insert(marble: 8)
        circle.insert(marble: 9)
        let answer = circle.removeMarble()
        XCTAssertEqual(1, answer)
        XCTAssertEqual([0, 8, 4, 9, 2, 5, 6, 3, 7], circle.array)
        XCTAssertEqual(9, circle.count)
    }

    func testPlayLogic() {
        let day = DayNine()

        var answer = day.play(players: 9, until: 25)
        XCTAssertEqual(32, answer)

        answer = day.play(players: 10, until: 1618)
        XCTAssertEqual(8317, answer)

        answer = day.play(players: 13, until: 7999)
        XCTAssertEqual(146373, answer)

        answer = day.play(players: 17, until: 1104)
        XCTAssertEqual(2764, answer)

        answer = day.play(players: 21, until: 6111)
        XCTAssertEqual(54718, answer)

        answer = day.play(players: 30, until: 5807)
        XCTAssertEqual(37305, answer)
    }

}
