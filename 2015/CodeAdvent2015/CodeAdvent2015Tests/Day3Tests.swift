//
//  Day3Tests.swift
//  CodeAdvent2015
//
//  Created by Shawn Veader on 12/18/15.
//  Copyright © 2015 V8 Logic. All rights reserved.
//

import XCTest

class Day3Tests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testSantaVisitsTwoHouses() {
        _ = [">", "^v^v^v^v^v"].map {
            let tracker = SantaTracker()
            tracker.navigate($0)
            XCTAssertEqual(2, tracker.housesVisited())
        }
    }

    func testSantaVisitsFourHouses() {
        let tracker = SantaTracker()
        tracker.navigate("^>v<")
        XCTAssertEqual(4, tracker.housesVisited())
    }

    func testWithRobotSantaVisitsThreeHouses() {
        _ = ["^v", "^>v<"].map {
            let housesCount = trackWithRobot($0)
            XCTAssertEqual(3, housesCount)
        }
    }

    func testWithRobotSantaVisitsElevenHouses() {
        let housesCount = trackWithRobot("^v^v^v^v^v")
        XCTAssertEqual(11, housesCount)
    }
}
