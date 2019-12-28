//
//  DayTwentyOne.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/22/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DayTwentyOne: AdventDay {
    var dayNumber: Int = 21

    func partOne(input: String?) -> Any {
        var droid = SpringDroid(input: input ?? "")
        droid.instructions = [
            // .NOT(X: .A, Y: .J), // fails on #####.##.########
            // .NOT(X: .B, Y: .J), // fails on #####...######### <- also .C
            // .NOT(X: .D, Y: .J), // fails on #####.########### <- also lone .WALK

            // jump any time there is a piece of ground at the jump distance away
            .NOT(X: .D, Y: .T),
            .NOT(X: .T, Y: .J),

            .WALK,
        ]
        droid.run()

        return 0
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
