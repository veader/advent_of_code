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
    var stars = 2

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
            // let zeros = bits.filter({ $0 == 0 }).count
            let zeros = bits.count - ones

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

    func calculatePartTwo(_ reports: [[Int]]) -> (ohTwo: Int, seeOhTwo: Int) {
        let ohTwo = calcRating(reports: reports)
        let seeOhTwo = calcRating(reports: reports, most: false)
        return (ohTwo, seeOhTwo)
    }

    func calcRating(reports: [[Int]], index: Int = 0, most: Bool = true) -> Int {
        // if we only have one report yet, then it is our answer
        if reports.count == 1, let rating = reports.first {
            let binary = rating.map(String.init).joined()
            return Int(binary, radix: 2) ?? Int.min
        }

        // pull bits for remaining reports at the given index
        let bits = reports.map { $0[index] }

        var criteria = 0
        let ones = bits.filter({ $0 == 1 }).count
        let zeros = bits.count - ones

        // determine criteria
        if ones == zeros {
            // case where they are equally common
            if most {
                criteria = 1
            } else {
                criteria = 0
            }
        } else if ones > (bits.count - ones) {
            if most {
                criteria = 1
            } else {
                criteria = 0
            }
        } else {
            if most {
                criteria = 0
            } else {
                criteria = 1
            }
        }

        let filteredReports = reports.filter { $0[index] == criteria }

        return calcRating(reports: filteredReports, index: index + 1, most: most)
    }

    func partOne(input: String?) -> Any {
        let reports = parse(input)
        let rates = calcualtePartOne(reports)
        return rates.gamma * rates.epsilon
    }

    func partTwo(input: String?) -> Any {
        let reports = parse(input)
        let ratings = calculatePartTwo(reports)
        return ratings.ohTwo * ratings.seeOhTwo
    }
}
