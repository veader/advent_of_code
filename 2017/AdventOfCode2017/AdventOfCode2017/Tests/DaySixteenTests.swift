//
//  DaySixteenTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/18/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension DaySixteen: Testable {
    func runTests() {
        let data = "s1,x3/4,pe/b"

        let dancers = "abcde".map(String.init)
        var dance = Dance(data)
        dance.dancers = dancers
        dance.perform(printing: false)


        guard
            testValue("baedc", equals: dance.dancers.joined())
            else {
                print("Part 1 Tests Failed!")
                return
        }

//        guard
//            testValue(309, equals: partTwo(input: input))
//            else {
//                print("Part 2 Tests Failed!")
//                return
//        }

        print("Done with tests... all pass")
    }
}
