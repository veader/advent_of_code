//
//  Day14_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/14/23.
//

import Foundation

struct Day14_2023: AdventDay {
    var year = 2023
    var dayNumber = 14
    var dayTitle = "Parabolic Reflector Dish"
    var stars = 1

    func partOne(input: String?) -> Any {
        let dish = ReflectorDish(input ?? "")
        dish.tilt()
        return dish.calculateLoad()
    }

    func partTwo(input: String?) -> Any {
        let dish = ReflectorDish(input ?? "")
        return 0
    }
}
