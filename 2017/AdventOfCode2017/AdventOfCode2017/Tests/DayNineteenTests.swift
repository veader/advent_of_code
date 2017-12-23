//
//  DayNineteenTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/22/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension DayNineteen: Testable {
    func runTests() {
        let input = """
                |
                |  +--+
                A  |  C
            F---|----E|--+
                |  |  |  D
                +B-+  +--+
            """

        guard
            testValue("ABCDEF", equals: partOne(input: input))
            else {
                print("Part 1 Tests Failed!")
                return
            }

//        guard
//            testValue("foo", equals: partTwo(input: input))
//            else {
//                print("Part 2 Tests Failed!")
//                return
//            }

        print("Done with tests... all pass")
    }
}
