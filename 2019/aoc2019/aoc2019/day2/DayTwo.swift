//
//  DayTwo.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/2/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DayTwo: AdventDay {
    var dayNumber: Int = 2

    @discardableResult func run(_ input: String? = nil, _ part: Int? = 1) -> Any {
        guard let input = input ?? defaultInput else {
            print("Day \(dayNumber): NO INPUT")
            exit(10)
        }

        let ints = input.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ",").compactMap { Int($0) }

        if part == 1 {
            let answer = partOne(input: ints)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        } else {
            let answer = 0 //partTwo(modules)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
        }
    }

    func partOne(input: [Int]) -> Int {
        var machine = IntCodeMachine(input: input)
        // alter values at 1 and 2
        machine.ints[1] = 12
        machine.ints[2] = 2

        machine.run()

        return machine.ints[0]
    }

    func partTwo(_ modules: [Int]) -> Int {
        return modules.reduce(0) { (result, mass) -> Int in
            let fuel = fuelForMass(mass)
            let fuelCost = fuelCostForMass(fuel)
            return result + fuel + fuelCost
        }
    }

    func fuelForMass(_ mass: Int) -> Int {
        guard mass > 0 else { return 0 }

        var dividedMass: Float = Float(mass) / 3.0
        dividedMass.round(.down)

        let fuel = Int(dividedMass) - 2

        guard fuel > 0 else { return 0 }
        return fuel
    }

    func fuelCostForMass(_ mass: Int) -> Int {
        var costs = [Int]()
        var currentMass = mass

        while currentMass > 0 {
            currentMass = fuelForMass(currentMass)
            costs.append(currentMass)
        }

        return costs.reduce(0, +)
    }
}
