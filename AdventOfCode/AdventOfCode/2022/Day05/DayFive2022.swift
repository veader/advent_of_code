//
//  DayFive2022.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/5/22.
//

import Foundation

struct DayFive2022: AdventDay {
    var year = 2022
    var dayNumber = 5
    var dayTitle = "Supply Stacks"
    var stars = 2

    func parse(_ input: String?) -> SupplyCrateMap {
        SupplyCrateMap.parse(input)
    }

    func partOne(input: String?) -> Any {
        var stackMap = parse(input)
        stackMap.followAllInstructions()
        return stackMap.topBoxes().compactMap { box -> String? in
            guard case .box(let name) = box else { return nil }
            return name
        }.joined()
    }

    func partTwo(input: String?) -> Any {
        var stackMap = parse(input)
        stackMap.followAllInstructions(grouped: true)
        return stackMap.topBoxes().compactMap { box -> String? in
            guard case .box(let name) = box else { return nil }
            return name
        }.joined()
    }
}
