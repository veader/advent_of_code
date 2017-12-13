//
//  DayElevenTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/11/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension DayEleven: Testable {
    func runTests() {
        guard
            testValue(3, equals: partOne(input: "ne,ne,ne")),
            testValue(0, equals: partOne(input: "ne,ne,sw,sw")),
            testValue(2, equals: partOne(input: "ne,ne,s,s")),
            testValue(3, equals: partOne(input: "se,sw,se,sw,sw")),
            true
            else {
                print("Part 1 Tests Failed!")
                return
        }

        print("Done with tests... all pass")
    }
}
