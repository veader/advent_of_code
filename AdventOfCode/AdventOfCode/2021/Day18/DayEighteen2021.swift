//
//  DayEighteen2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/19/21.
//

import Foundation

struct DayEighteen2021: AdventDay {
    var year = 2021
    var dayNumber = 18
    var dayTitle = "Snailfish"
    var stars = 1

    func parse(_ input: String?) -> [SnailfishNumber] {
        (input ?? "").split(separator: "\n").map(String.init).compactMap { SnailfishNumber.parse($0) }
    }

    func add(numbers: [SnailfishNumber]) -> SnailfishNumber {
        var numbers = numbers
        var accumulator = numbers.removeFirst()
        while !numbers.isEmpty {
            let next = numbers.removeFirst()
            let adder = SnailfishNumber.add(accumulator, next)
            adder.reduce()
            accumulator = adder
        }

        return accumulator
    }

    func partOne(input: String?) -> Any {
        let snailNum = add(numbers: parse(input))
        return snailNum.magnitude()
    }

    func partTwo(input: String?) -> Any {
        return Int.min
    }
}
