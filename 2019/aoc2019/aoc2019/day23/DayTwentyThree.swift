//
//  DayTwentyThree.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/30/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DayTwentyThree: AdventDay {
    var dayNumber: Int = 23

    // func parse(_ input: String?) -> FOO { return FOO... }

    func partOne(input: String?) -> Any {
        let computers = 50

        let network = Network(count: computers, instructions: input ?? "")
        network.setupComputers()
        network.go()

        return 0
    }

    func partTwo(input: String?) -> Any {
        let computers = 50

        let network = Network(count: computers, instructions: input ?? "")
        network.useNAT = true
        network.setupComputers()
        network.go()

        return 0
    }
}
