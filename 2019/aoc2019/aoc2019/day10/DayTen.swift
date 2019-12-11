//
//  DayTen.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/10/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DayTen: AdventDay {
    var dayNumber: Int = 10

    func partOne(input: String?) -> Any {
        let map = SpaceMap(input: input ?? "")
        guard let location = map.maxVisibilityLocation() else { return 0 }
        return map.visibility(at: location)
    }

    func partTwo(input: String?) -> Any {
        let map = SpaceMap(input: input ?? "")
        guard let location = map.maxVisibilityLocation() else { return 0 }
        map.laserStation = SpaceLaser(width: map.width, height: map.height, location: location)
        return 0
    }
}
