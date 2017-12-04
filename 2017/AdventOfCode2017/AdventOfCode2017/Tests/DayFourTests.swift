//
//  DayFour.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/4/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

extension DayFour: Testable {
    func runTests() {
        let data = [
            "aa bb cc dd ee",
            "aa bb cc dd aa",
            "aa bb cc dd aaa",
            ]
        guard Passphrase(data[0]).isValid(),
              !Passphrase(data[1]).isValid(),
              Passphrase(data[2]).isValid(),
              testValue(2, equals: partOne(input: data)),
              true
            else {
                print("Part 1 Tests Failed!")
                return
        }

        print("Done with tests... all pass")
    }
}
