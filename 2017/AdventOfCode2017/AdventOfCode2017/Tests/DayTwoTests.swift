//
//  DayTwo.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/4/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

extension DayTwo: Testable {
    func runTests() {
        let data = """
            5 1 9 5
            7 5 3
            2 4 6 8
            """

        guard testValue(18, equals: partOne(input: data))
              else {
                  print("Part 1 Tests Failed!")
                  return
              }

        let data2 = """
            5 9 2 8
            9 4 7 3
            3 8 6 5
            """

        guard testValue(9, equals: partTwo(input: data2))
              else {
                  print("Part 2 Tests Failed!")
                  return
              }

        print("Done with tests... all pass")
    }
}
