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

    func run(_ input: String? = nil) {
        guard let input = input ?? defaultInput else {
            print("Day \(dayNumber): NO INPUT")
            exit(10)
        }

        let freqShifts = input.split(separator: "\n").compactMap { Int($0) }

        var freq = 0

        for freqShift in freqShifts {
            freq += freqShift
        }

        print("Day \(dayNumber): Final Answer \(freq)")
    }
}
