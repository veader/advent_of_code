//
//  DayOne.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/4/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

extension DayOne: Testable {
    func runTests() {
        guard testValue(3, equals: partOne(input: "1122")),
              testValue(4, equals: partOne(input: "1111")),
              testValue(0, equals: partOne(input: "1234")),
              testValue(9, equals: partOne(input: "91212129"))
              else {
                  print("Part 1 Tests Failed!")
                  return
              }

        guard testValue(6, equals: partTwo(input: "1212")),
              testValue(0, equals: partTwo(input: "1221")),
              testValue(4, equals: partTwo(input: "123425")),
              testValue(12, equals: partTwo(input: "123123")),
              testValue(4, equals: partTwo(input: "12131415"))
              else {
                  print("Part 2 Tests Failed!")
                  return
              }

        print("Done with tests... all pass")
    }
}
