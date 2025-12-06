//
//  Day6_2025.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/5/25.
//

import Foundation

struct Day6_2025: AdventDay {
    var year = 2025
    var dayNumber = 6
    var dayTitle = "Trash Compactor"
    var stars = 1

    func parse(_ input: String?) -> MathHomework? {
        MathHomework.parse(input ?? "")
    }

    func partOne(input: String?) -> Any {
        guard let homework = parse(input) else { return 0 }
        return homework.grandTotal()
    }

    func partTwo(input: String?) -> Any {
        let homework = parse(input)
        return 0
    }
}
