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
    var stars = 2

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
        var magnitudes = [SnailfishNumber: Int]()
        var numbers = parse(input)

        var current = numbers.removeFirst()
        while !numbers.isEmpty {
            numbers.forEach { num in
                let currentDesc = current.description
                let numDesc = num.description

                let curLeft = SnailfishNumber.parse(currentDesc)
                let numRight = SnailfishNumber.parse(numDesc)
//                print("Adding: \(curLeft!) + \(numRight!)")
                let sn1 = SnailfishNumber.add(curLeft!, numRight!)
                sn1.reduce()
                magnitudes[sn1] = sn1.magnitude()

                let numLeft = SnailfishNumber.parse(numDesc)
                let curRight = SnailfishNumber.parse(currentDesc)
//                print("Adding: \(numLeft!) + \(curRight!)")
                let sn2 = SnailfishNumber.add(numLeft!, curRight!)
                sn2.reduce()
                magnitudes[sn2] = sn2.magnitude()
            }

            current = numbers.removeFirst()
        }

        if let largest = magnitudes.max(by: { $0.value < $1.value }) {
            print(largest)
            return largest
        } else {
            return Int.min
        }
    }
}
