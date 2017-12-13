//
//  DayTwelveTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/12/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension DayTwelve: Testable {
    func runTests() {
        guard
            Village.Pipe("foo") == nil,
            let pipe = Village.Pipe("1 <-> 4, 6,5"),
            testValue(1, equals: pipe.origin),
            testValue(4, equals: pipe.destinations.first),
            testValue(6, equals: pipe.destinations.last),
            testValue(3, equals: pipe.destinations.count),
            true
            else {
                print("Pipe Tests Failed!")
                return
        }

        let data = """
        0 <-> 2
        1 <-> 1
        2 <-> 0, 3, 4
        3 <-> 2, 4
        4 <-> 2, 3, 6
        5 <-> 6
        6 <-> 4, 5
        """
        guard
            testValue(6, equals: partOne(input: data)),
            true
            else {
                print("Part 1 Tests Failed!")
                return
        }

        print("Done with tests... all pass")
    }
}
