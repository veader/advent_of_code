//
//  DayEight.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/8/20.
//

import Foundation

struct DayEight2020: AdventDay {
    var year = 2020
    var dayNumber = 8
    var dayTitle = "Handheld Halting"
    var stars = 2

    func parse(_ input: String?) -> [String] {
        (input ?? "").split(separator: "\n").map(String.init)
    }

    func partOne(input: String?) -> Any {
        let bootCode = BootCode(parse(input))
        bootCode.detectLoop()
        return bootCode.accumulator
    }

    func partTwo(input: String?) -> Any {
        let bootCode = BootCode(parse(input))
        bootCode.fixLoop()
        return bootCode.accumulator
    }
}
