//
//  DayTwelve.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/12/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DayTwelve: AdventDay {
    var dayNumber: Int = 12

    func parse(_ input: String?) -> [Moon] {
        (input ?? "").split(separator: "\n")
            .map(String.init)
            .compactMap { Moon(input: $0) }
    }

    func partOne(input: String?) -> Any {
        let moons = parse(input)
        let simulation = MoonSimulation(moons: moons)
        simulation.step(count: 1000)

        return simulation.totalEnergy
    }

    func partTwo(input: String?) -> Any {
        let moons = parse(input)
        let simulation = MoonSimulation(moons: moons)

        let cycles = simulation.calculateCycles()
        print(cycles)

        let min = [cycles.x, cycles.y, cycles.z].min() ?? 0
        var loopCount = min

        while loopCount % cycles.x != 0 || loopCount % cycles.y != 0 || loopCount % cycles.z != 0 {
            loopCount += min
        }

        return loopCount
    }
}
