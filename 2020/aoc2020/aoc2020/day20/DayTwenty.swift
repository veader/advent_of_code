//
//  DayTwenty.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/20/20.
//

import Foundation

struct DayTwenty: AdventDay {
    var dayNumber: Int = 20

    func parse(_ input: String?) -> SatelliteImage {
        SatelliteImage(input ?? "")
    }

    func partOne(input: String?) -> Any {
        let image = parse(input)
        let cornerIDs = image.findCorners()
        return cornerIDs.reduce(1, *)
    }

    func partTwo(input: String?) -> Any {
        return -1
    }
}
