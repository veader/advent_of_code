//
//  DayEighteenTests.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/20/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

extension DayEighteen: Testable {
    func runTests() {
        let input = """
            set a 1
            add a 2
            mul a a
            mod a 5
            snd a
            set a 0
            rcv a
            jgz a -1
            set a 1
            jgz a -2
            """

//        var duet = Duet(input)
//        let lastSound = duet.play(printing: true)
//        print(lastSound)

        guard
            testValue(4, equals: partOne(input: input))
            else {
                print("Part 1 Tests Failed!")
                return
        }

        /*
        guard
            testValue(0, equals: partTwo(input: input))
            else {
                print("Part 2 Tests Failed!")
                return
        }
         */

        print("Done with tests... all pass")
    }
}
