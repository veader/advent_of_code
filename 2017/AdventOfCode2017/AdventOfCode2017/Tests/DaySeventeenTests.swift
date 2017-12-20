//
//  DaySeventeenTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/19/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension DaySeventeen: Testable {
    func runTests() {
        let input = 3

        guard
            testValue(638, equals: partOne(input: input))
            else {
                print("Part 1 Tests Failed!")
                return
        }

//        guard
//            testValue(0, equals: partTwo(input: input))
//            else {
//                print("Part 2 Tests Failed!")
//                return
//        }

        print("Done with tests... all pass")
    }
}
