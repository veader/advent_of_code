//
//  DayThree2020.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/3/21.
//

import Foundation

struct DayThree2021: AdventDay {
    var year = 2021
    var dayNumber = 3
    var dayTitle = "Binary Diagnostic"
    var stars = 1

    func parse(_ input: String?) -> [[Int]] {
        (input ?? "")
            .split(separator: "\n")
            .map { line in
                line.compactMap { Int(String($0)) }
            }
    }

    func calcualtePartOne(_ reports: [[Int]]) -> (gamma: Int, epsilon: Int) {
        var gammaString = ""
        var epsilonString = ""

        let count = reports.first?.count ?? 0
        guard reports.filter({$0.count == count}).count == reports.count else {
            print("Different sized words given...")
            return (Int.min, Int.min)
        }

        (0..<count).forEach { idx in
            let bits = reports.map { $0[idx] }
            let ones = bits.filter({ $0 == 1 }).count
            let zeros = bits.filter({ $0 == 0 }).count

            if ones > zeros {
                gammaString.append("1")
                epsilonString.append("0")
            } else {
                gammaString.append("0")
                epsilonString.append("1")
            }
        }

        print("Gamma: \(gammaString), Epsilon: \(epsilonString)")
        return (Int(gammaString, radix: 2) ?? Int.min,
                Int(epsilonString, radix: 2) ?? Int.min)
    }

    func partOne(input: String?) -> Any {
        let reports = parse(input)
        let rates = calcualtePartOne(reports)
        return rates.gamma * rates.epsilon
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
