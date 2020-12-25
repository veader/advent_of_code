//
//  DayTwentyOne.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/24/20.
//

import Foundation

struct DayTwentyOne: AdventDay {
    var dayNumber: Int = 21

    func parse(_ input: String?) -> Groceries {
        Groceries(input ?? "")
    }

    func partOne(input: String?) -> Any {
        let groceries = parse(input)
        // groceries.findSafeIngredients()
        return groceries.safeIngredientAppearanceCount()
    }

    func partTwo(input: String?) -> Any {
        return -1
    }
}
