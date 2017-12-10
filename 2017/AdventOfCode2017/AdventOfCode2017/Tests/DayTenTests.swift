//
//  DayTenTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/10/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension DayTen: Testable {
    func runTests() {
        guard
            testValue(12, equals: partOne(input: "3, 4, 1, 5", count: 5)),
            true
            else {
                print("Part 1 Tests Failed!")
                return
        }

        guard
            testValue("33efeb34ea91902bb2f59c9920caa6cd", equals: partTwo(input: "AoC 2017")),
            testValue("a2582a3a0e66e6e86e3812dcb672a272", equals: partTwo(input: "")),
            testValue("3efbe78a8d82f29979031a4aa0b16a9d", equals: partTwo(input: "1,2,3")),
            testValue("63960835bcdc130f0b66d7ff4f6a5a8e", equals: partTwo(input: "1,2,4")),
            true
            else {
                print("Part 2 Tests Failed!")
                return
        }

        print("Done with tests... all pass")
    }
}
