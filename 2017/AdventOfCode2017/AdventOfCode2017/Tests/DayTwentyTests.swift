//
//  DayTwentyTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/23/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension DayTwenty: Testable {
    func runTests() {

        guard
            let vector = Vector("1,2,3"),
            testValue(1, equals: vector.x),
            testValue(2, equals: vector.y),
            testValue(3, equals: vector.z),
            let vector2 = Vector("=<-317,1413,1507>, v"),
            testValue(-317, equals: vector2.x),
            testValue(1413, equals: vector2.y),
            testValue(1507, equals: vector2.z),
            true
            else {
                print("Vector parsing failure")
                return
            }


        let input = """
                    p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>
                    p=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>
                    """

        guard
            testValue(0, equals: partOne(input: input))
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
