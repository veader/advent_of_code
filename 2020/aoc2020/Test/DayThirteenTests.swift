//
//  DayThirteenTests.swift
//  Test
//
//  Created by Shawn Veader on 12/14/20.
//

import XCTest

class DayThirteenTests: XCTestCase {

    func testBusScheduleParser() {
        let schedule = BusSchedule.parse(testInput)
        XCTAssertNotNil(schedule)
        XCTAssertEqual(939, schedule?.earliestDepartureTime)
        XCTAssertEqual(5, schedule?.buses.count)
        XCTAssert(schedule!.buses.contains(7))
        XCTAssert(schedule!.buses.contains(19))
    }

    func testBusScheduleFindBus() {
        let schedule = BusSchedule.parse(testInput)!
        let answer = schedule.findEarliestBus(brute: true)
        XCTAssertEqual(944, answer.time)
        XCTAssertEqual(59, answer.bus)
    }

    let testInput = """
        939
        7,13,x,x,59,x,31,19
        """
}
