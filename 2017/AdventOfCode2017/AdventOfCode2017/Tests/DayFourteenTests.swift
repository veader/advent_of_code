//
//  DayFourteenTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/15/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension DayFourteen: Testable {
    func runTests() {
        let key = "flqrgnkx"

        guard
            testValue(8108, equals: partOne(input: key))
            else {
                print("Part 1 Tests Failed!")
                return
        }

        print("Done with tests... all pass")
    }
}
