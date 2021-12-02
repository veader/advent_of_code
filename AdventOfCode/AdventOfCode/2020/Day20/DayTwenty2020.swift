//
//  DayTwenty.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/20/20.
//

import Foundation

struct DayTwenty2020: AdventDay {
    var year = 2020
    var dayNumber = 20
    var dayTitle = "Jurassic Jigsaw"
    var stars = 1

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
