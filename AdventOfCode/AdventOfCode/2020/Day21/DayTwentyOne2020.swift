//
//  DayTwentyOne.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/24/20.
//

import Foundation

struct DayTwentyOne2020: AdventDay {
    var year = 2020
    var dayNumber = 21
    var dayTitle = "Allergen Assessment"
    var stars = 1

    func parse(_ input: String?) -> Groceries {
        Groceries(input ?? "")
    }

    func partOne(input: String?) -> Any {
        let groceries = parse(input)
        return groceries.safeIngredientAppearanceCount()
    }

    func partTwo(input: String?) -> Any {
        let groceries = parse(input)
        let dangerous = groceries.findDangerousIngredients()
        return dangerous.joined(separator: ",")
    }
}
