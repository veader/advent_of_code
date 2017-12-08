//
//  DayEightTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/8/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension DayEight: Testable {
    func runTests() {
        let data = """
            b inc 5 if a > 1
            a inc 1 if b < 5
            c dec -10 if a >= 1
            c inc -20 if c == 10
            """

        guard
            testValue(1, equals: partOne(input: data)),
            true
            else {
                print("Part 1 Tests Failed!")
                return
        }

//        guard
//            testValue(60, equals: partTwo(input: data)),
//            true
//            else {
//                print("Part 2 Tests Failed!")
//                return
//        }

        print("Done with tests... all pass")
    }
}
