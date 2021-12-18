//
//  DavSeventeen2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/17/21.
//

import Foundation

struct DavSeventeen2021: AdventDay {
    var year = 2021
    var dayNumber = 17
    var dayTitle = "Trick Shot"
    var stars = 0

    // Puzzle Input
    // target area: x=265..287, y=-103..-58
    let targetAreaX = (265 ... 287)
    let targetAreaY = (-103 ... -58)

    func partOne(input: String?) -> Any {
        let trickShot = TrickShot(areaX: targetAreaX, areaY: targetAreaY)
        trickShot.findShots()
        return trickShot.highestHeight
    }

    func partTwo(input: String?) -> Any {
        let trickShot = TrickShot(areaX: targetAreaX, areaY: targetAreaY)
        trickShot.findShots()
        return trickShot.workingShots.count
    }
}
