//
//  DayThree.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/4/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

extension DayThree: Testable {
    func runTests() {
        guard testValue(0, equals: partOne(input: 1)),
              testValue(1, equals: partOne(input: 2)),
              testValue(2, equals: partOne(input: 3)),
              testValue(2, equals: partOne(input: 23)),
              testValue(6, equals: partOne(input: 75)),
              testValue(8, equals: partOne(input: 81)),
              true
              else {
                  print("Part 1 Tests Failed!")
                  return
              }

        guard testValue(23, equals: partTwo(input: 20))
              else {
                  print("Part 2 Tests Failed!")
                  return
              }

        print("Done with tests... all pass")
    }
}
