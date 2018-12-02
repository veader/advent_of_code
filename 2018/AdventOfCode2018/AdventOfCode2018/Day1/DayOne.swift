//
//  DayOne.swift
//  AdventOfCode2018
//
//  Created by Shawn Veader on 12/2/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import Foundation

struct DayOne: AdventDay {

    var dayNumber: Int = 1

    @discardableResult func run(_ input: String? = nil, _ part: Int? = 1) -> Any {
        guard let input = input ?? defaultInput else {
            print("Day \(dayNumber): NO INPUT")
            exit(10)
        }

        var freq: Int = Int.min

        if part == 1 {
            freq = partOne(input: input)
        } else {
            freq = partTwo(input: input)
        }

        print("Day \(dayNumber) Part \(part!): Final Answer \(freq)")

        return freq
    }

    func partOne(input: String) -> Int {
        let freqShifts = input.split(separator: "\n").compactMap { Int($0) }

        return freqShifts.reduce(0, +)
    }

    func partTwo(input: String) -> Int {
        return Int.min
    }
}

