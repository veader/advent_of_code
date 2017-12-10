//
//  DayNineTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/9/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension DayNine: Testable {
    func runTests() {
        guard
            testValue("", equals: Garbage.parse("<>").0?.content),
            testValue("random characters", equals: Garbage.parse("<random characters>").0?.content),
            testValue("<<<", equals: Garbage.parse("<<<<>").0?.content),
            testValue("{!>}", equals: Garbage.parse("<{!>}>").0?.content),
            testValue("!!", equals: Garbage.parse("<!!>").0?.content),
            testValue("!!!>", equals: Garbage.parse("<!!!>>").0?.content),
            testValue("{o\"i!a,<{i<a", equals: Garbage.parse("<{o\"i!a,<{i<a>").0?.content),
            true
            else {
                print("Garbage Parsing Tests Failed!")
                return
            }

        guard
            testValue("", equals: Garbage.parse("<>").0?.notCanceled),
            testValue("random characters", equals: Garbage.parse("<random characters>").0?.notCanceled),
            testValue("<<<", equals: Garbage.parse("<<<<>").0?.notCanceled),
            testValue("{}", equals: Garbage.parse("<{!>}>").0?.notCanceled),
            testValue("", equals: Garbage.parse("<!!>").0?.notCanceled),
            testValue("", equals: Garbage.parse("<!!!>>").0?.notCanceled),
            testValue("{o\"i,<{i<a", equals: Garbage.parse("<{o\"i!a,<{i<a>").0?.notCanceled),
            true
            else {
                print("Garbage Parsing (Canceled) Tests Failed!")
                return
        }

        guard
            testValue(1, equals: partOne(input: "{}")),
            testValue(6, equals: partOne(input: "{{{}}}")),
            testValue(5, equals: partOne(input: "{{},{}}")),
            testValue(16, equals: partOne(input: "{{{},{},{{}}}}")),
            testValue(1, equals: partOne(input: "{<a>,<a>,<a>,<a>}")),
            testValue(9, equals: partOne(input: "{{<ab>},{<ab>},{<ab>},{<ab>}}")),
            testValue(9, equals: partOne(input: "{{<!!>},{<!!>},{<!!>},{<!!>}}")),
            testValue(3, equals: partOne(input: "{{<a!>},{<a!>},{<a!>},{<ab>}}")),
            true
            else {
                print("Part 1 Tests Failed!")
                return
        }

//        print(Group.parse("{{{}}}").0 ?? "")
//        print(Group.parse("{{},{}}").0 ?? "")
//        print(Group.parse("{{{},{},{{}}}}").0 ?? "")
//        print(Group.parse("{<a>,<a>,<a>,<a>}").0 ?? "")
//        print(Group.parse("{{<ab>},{<ab>},{<ab>},{<ab>}}").0 ?? "")
//        print(Group.parse("{{<!!>},{<!!>},{<!!>},{<!!>}}").0 ?? "")
//        print(Group.parse("{{<a!>},{<a!>},{<a!>},{<ab>}}").0 ?? "")

//        guard
//            testValue(10, equals: partTwo(input: "")),
//            true
//            else {
//                print("Part 2 Tests Failed!")
//                return
//        }

        print("Done with tests... all pass")
    }
}
