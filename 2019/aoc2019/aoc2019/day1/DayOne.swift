//
//  DayOne.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/1/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DayOne: AdventDay {
    var dayNumber: Int = 1

    @discardableResult func run(_ input: String? = nil, _ part: Int? = 1) -> Any {
        guard let input = input ?? defaultInput else {
            print("Day \(dayNumber): NO INPUT")
            exit(10)
        }

        let modules = input.split(separator: "\n").compactMap { Int($0) }

        if part == 1 {
            let answer = partOne(modules)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        } else {
            let answer: String = ""//partTwo(tree: tree)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        }
    }

    func partOne(_ modules: [Int]) -> Int {
        return modules.reduce(0) { (result, mass) -> Int in
            result + fuelForMass(mass)
        }
    }

    func fuelForMass(_ mass: Int) -> Int {
        guard mass > 0 else { return 0 }

        var dividedMass: Float = Float(mass) / 3.0
        dividedMass.round(.down)

        return Int(dividedMass) - 2
    }

    /*
    func partTwo(tree: LicenseTree) -> Int {
        guard let rootNode = tree.rootNode else { return Int.min }
        return sumNodeValue(for: rootNode)
    }
     */
}
