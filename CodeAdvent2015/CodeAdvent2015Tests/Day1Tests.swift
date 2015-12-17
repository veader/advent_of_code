//
//  Day1Tests.swift
//  CodeAdvent2015
//
//  Created by Shawn Veader on 12/17/15.
//  Copyright © 2015 V8 Logic. All rights reserved.
//

import XCTest

class Day1Tests: XCTestCase {
    var elevator = Elevator()

    override func setUp() {
        super.setUp()
        elevator.reset()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testElevatorEndsUpInLobby() {
        _ = ["(())", "()()"].map {
            elevator.reset()
            elevator.operate($0)
            XCTAssertEqual(0, elevator.current_floor)
        }
    }

    func testElevatorEndsUpOnThirdFloor() {
        _ = ["(((", "(()(()(", "))((((("].map {
            elevator.reset()
            elevator.operate($0)
            XCTAssertEqual(3, elevator.current_floor)
        }
    }

    func testElevatorEndsUpInFirstLevelOfBasement() {
        _ = ["())", "))("].map {
            elevator.reset()
            elevator.operate($0)
            XCTAssertEqual(-1, elevator.current_floor)
        }
    }

    func testElevatorEndsUpInThirdLevelOfBasement() {
        _ = [")))", ")())())"].map {
            elevator.reset()
            elevator.operate($0)
            XCTAssertEqual(-3, elevator.current_floor)
        }
    }

}
