//
//  DayFiveTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/5/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension DayFive: Testable {
    func runTests() {
        let data = [0, 3, 0, 1, -3]

        guard testValue(5, equals: partOne(input: data)) else {
            print("Part 1 Tests Failed!")
            return
        }

        guard testValue(10, equals: partTwo(input: data)) else {
            print("Part 2 Tests Failed!")
            return
        }

        print("Done with tests... all pass")
    }
}
