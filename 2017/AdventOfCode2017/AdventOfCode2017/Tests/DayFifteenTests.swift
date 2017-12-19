//
//  DayFifteenTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/18/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension DayFifteen: Testable {
    func runTests() {
        let input = [65, 8921]

//        print(Date())
//        var judge = Judge(a: input[0], b: input[1], useMultiples: true)
//        let cycles = 2_000 // 40_000_000 // 5
//        let matches = judge.compare(cycles: cycles) //, printing: true)
//        print(matches)
//        print(Date())

        guard
            testValue(588, equals: partOne(input: input))
            else {
                print("Part 1 Tests Failed!")
                print(Date())
                return
        }

        guard
            testValue(309, equals: partTwo(input: input))
            else {
                print("Part 2 Tests Failed!")
                print(Date())
                return
        }

        print("Done with tests... all pass")
    }
}
