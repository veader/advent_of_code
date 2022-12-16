//
//  DayThirteen2022.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/13/22.
//

import Foundation

struct DayThirteen2022: AdventDay {
    var year = 2022
    var dayNumber = 13
    var dayTitle = "Distress Signal"
    var stars = 0

    func partOne(input: String?) -> Any {
        let signal = DistressSignal(input ?? "")
        let correctPairs = signal.correctPairs()//index: 1)

        for correctIdx in correctPairs {
            print("Pair \(correctIdx)")
        }
        return correctPairs.reduce(0, +)

        // 756 - too low
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
