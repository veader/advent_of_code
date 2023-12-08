//
//  Day8_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/8/23.
//

import Foundation

struct Day8_2023: AdventDay {
    var year = 2023
    var dayNumber = 8
    var dayTitle = "Haunted Wasteland"
    var stars = 1

    func partOne(input: String?) -> Any {
        let wasteland = WastelandMap(input ?? "")
        let answer = try? wasteland.followDirections()
        return answer ?? -1
    }

    func partTwo(input: String?) -> Any {
        return 0
    }

}
