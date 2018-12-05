//
//  DayFourTests.swift
//  Test
//
//  Created by Shawn Veader on 12/3/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import XCTest

class DayFourTests: XCTestCase {
    let guardInput = """
                     [1518-11-01 00:00] Guard #10 begins shift
                     [1518-11-01 00:05] falls asleep
                     [1518-11-01 00:25] wakes up
                     [1518-11-01 00:30] falls asleep
                     [1518-11-01 00:55] wakes up
                     """
    lazy var guardInput2 = """
                           \(guardInput)
                           [1518-11-03 00:05] Guard #10 begins shift
                           [1518-11-03 00:24] falls asleep
                           [1518-11-03 00:29] wakes up
                           """

    func testProcessingLines() {
        let day = DayFour()
        let shifts = day.process(input: guardInput)
        XCTAssertEqual(1, shifts.count)
    }

    func testShiftLogic() {
        let day = DayFour()
        let shifts = day.process(input: guardInput)
        guard let shift = shifts.first else { XCTFail(); return }

        XCTAssertEqual(2, shift.ranges.count)

        let shiftText = "11-01  #10  .....####################.....#########################....."
        XCTAssertEqual(shiftText, shift.debugDescription)

        XCTAssertEqual(45, shift.minutesAsleep)
    }

    func testGuardTest() {
        let day = DayFour()
        let shifts = day.process(input: guardInput2)

        let theGuard = DayFour.Guard(guardID: 10, shifts: shifts)
        XCTAssertEqual(50, theGuard.totalMinutesAsleep)
        theGuard.sleepMap.sorted(by: { $0.key < $1.key }).forEach {
            print("Min \($0.key): \($0.value)")
        }
        XCTAssertEqual(24, theGuard.sleepiestMinute)
    }

}
