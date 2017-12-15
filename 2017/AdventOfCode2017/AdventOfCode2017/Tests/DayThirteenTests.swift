//
//  DayThirteenTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/13/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension DayThirteen: Testable {
    func runTests() {
        let data = """
            0: 3
            1: 2
            4: 4
            6: 4
            """

        let firewall = Firewall(data)

        guard
            testValue(6, equals: firewall.maxLayerIndex),
            testValue(3, equals: firewall.layers[0]?.range),
            testValue(4, equals: firewall.depth(at: 4)),
            testValue(0, equals: firewall.depth(at: 2)),
            true
            else {
                print("Firewall Tests Failed!")
                return
            }

        guard
            testValue(24, equals: partOne(input: data)),
            true
            else {
                print("Part 1 Tests Failed!")
                return
            }

//        guard
//            testValue(2, equals: partOne(input: data))
//            else {
//                print("Part 1 Tests Failed!")
//                return
//        }

        print("Done with tests... all pass")
    }
}
