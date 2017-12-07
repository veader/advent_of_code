//
//  DaySevenTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/7/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension DaySeven: Testable {
    func runTests() {
        let data = """
            pbga (66)
            xhth (57)
            ebii (61)
            havc (66)
            ktlj (57)
            fwft (72) -> ktlj, cntj, xhth
            qoyq (66)
            padx (45) -> pbga, havc, qoyq
            tknk (41) -> ugml, padx, fwft
            jptl (61)
            ugml (68) -> gyxo, ebii, jptl
            gyxo (61)
            cntj (57)
            """
        
        guard
            testValue("tknk", equals: partOne(input: data)),
            true
            else {
                print("Part 1 Tests Failed!")
                return
        }

        guard
            testValue(60, equals: partTwo(input: data)),
            true
            else {
                print("Part 1 Tests Failed!")
                return
        }
        print("Done with tests... all pass")
    }
}
