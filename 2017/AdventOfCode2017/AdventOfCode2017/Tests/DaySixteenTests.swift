//
//  DaySixteenTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/18/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension DaySixteen: Testable {
    func runTests() {
        let data = "s1,x3/4,pe/b"

        let dancers = "abcde".map(String.init)
        var dance = Dance(data)
        dance.dancers = dancers
        dance.initialDancersState = dancers
        dance.perform(printing: false)

        if let shortSteps = dance.calculateSteps() {
            let results = dance.perform(steps: shortSteps, with: dancers, printing: false)
            assert(results.count > 0)
//            print(shortSteps)
//            print(results.joined())
        } else {
            print("No steps...")
        }

        guard
            testValue("baedc", equals: dance.dancers.joined())
            else {
                print("Part 1 Tests Failed!")
                return
        }

        var dance2 = Dance(data)
        dance2.dancers = dancers
        dance2.perform()
        dance2.recital(count: 2, printing: false)

        guard
            testValue("ceadb", equals: dance2.dancers.joined())
            else {
                print("Part 2 Tests Failed!")
                return
        }


        let path = "\(dataPath())/day16input.txt"
        if let realData = try? String(contentsOfFile: path, encoding: .utf8) {
            var dance3 = Dance(realData)
            var dance4 = Dance(realData)

            dance3.perform()
            dance4.perform()
            assert(dance3.dancersString == dance4.dancersString)

            if let steps = dance3.calculateSteps() {
                print("3 a: \(dance3.dancersString)")
                var results = dance3.perform(steps: steps, with: dance3.dancers)
                print("3 b: \(dance3.dancersString)")
                dance3.dancers = results
                print("3 c: \(dance3.dancersString)")
                dance4.perform()
                assert(dance3.dancersString == dance4.dancersString)

                results = dance3.perform(steps: steps, with: dance3.dancers)
                dance3.dancers = results
                dance4.perform()
                assert(dance3.dancersString == dance4.dancersString)

                print(dance3.dancersString)
                print(dance4.dancersString)
//                print(steps)
//                print(results.joined())
//                print(dance3.dancers.joined())
            }
        }


        print("Done with tests... all pass")
    }
}
