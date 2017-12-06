//
//  DaySixTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/6/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension DaySix: Testable {
    func runTests() {
        let memory = [0, 2, 7, 0]
        guard testValue(5, equals: partOne(input: memory)) else {
            print("Part 1 Tests Failed!")
            return
        }

        guard testValue(4, equals: partTwo(input: memory)) else {
            print("Part 2 Tests Failed!")
            return
        }

        print("Done with tests... all pass")
    }
}
