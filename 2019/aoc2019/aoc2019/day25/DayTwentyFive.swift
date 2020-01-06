//
//  DayTwentyFive.swift
//  aoc2019
//
//  Created by Shawn Veader on 1/5/20.
//  Copyright © 2020 Shawn Veader. All rights reserved.
//

import Foundation

struct DayTwentyFive: AdventDay {
    var dayNumber: Int = 25

    // func parse(_ input: String?) -> FOO { return FOO... }

    func partOne(input: String?) -> Any {
        let droid = SearchDroid(instructions: input ?? "")
        droid.setGatheringInstructions()
        droid.setGatherProperItemsInstructions()

        // droid.determineWeight = true
        droid.run()

        return 0
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
