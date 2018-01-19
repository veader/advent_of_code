//
//  DayTwentyFiveTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 1/7/18.
//  Copyright © 2018 v8logic. All rights reserved.
//

import Foundation

extension DayTwentyFive: Testable {
    func runTests() {
        let input = ""

        guard
            testValue(0, equals: partOne(input: input))
            else {
                print("Part 1 Tests Failed!")
                return
        }

        guard
            testValue(0, equals: partTwo(input: input))
            else {
                print("Part 2 Tests Failed!")
                return
        }

        print("Done with tests... all pass")
    }
}
