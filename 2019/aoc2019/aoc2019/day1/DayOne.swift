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

    func parse(_ input: String?) -> [Int] {
        return (input ?? "").split(separator: "\n").compactMap { Int($0) }
    }

    func partOne(input: String?) -> Any {
        let modules = parse(input)
        return modules.reduce(0) { (result, mass) -> Int in
            result + fuelForMass(mass)
        }
    }

    func partTwo(input: String?) -> Any {
        let modules = parse(input)
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
