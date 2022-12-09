//
//  DayEight2022.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/8/22.
//

import Foundation

struct DayEight2022: AdventDay {
    var year = 2022
    var dayNumber = 8
    var dayTitle = "Treetop Tree House"
    var stars = 1

    func partOne(input: String?) -> Any {
        guard let trees = TreeMap(input ?? "") else { return 0 }

        trees.detectVisibility()

        return trees.visibleCount()
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
