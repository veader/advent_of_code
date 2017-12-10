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

        print("Done with tests... all pass")
    }
}
