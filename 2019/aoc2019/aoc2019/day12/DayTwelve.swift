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
        let pairs = createPairs(moons: moons)

        runSteps(count: 1000, moons: moons, pairs: pairs)

        return moons.reduce(0) { $0 + $1.totalEnergy }
    }

    func runSteps(count: Int, moons: [Moon], pairs: [[Moon]]) {
        (0..<count).forEach { iteration in
            step(moons: moons, pairs: pairs)

            // print("After \(iteration + 1) steps:")
            // moons.forEach { print($0) }
            // print("")
        }
    }

    func partTwo(input: String?) -> Any {
        return 0
    }

    func step(moons: [Moon], pairs: [[Moon]]) {
        // first we apply gravity
        for pair in pairs {
            pair[0].applyGravity(toward: pair[1])
        }

        // next we apply velocity
        for moon in moons {
            moon.applyVelocity()
        }
    }

    func createPairs(moons: [Moon]) -> [[Moon]] {
        var theMoons = moons // copy so we can mutate it
        var moonPairs = [[Moon]]()

        while !theMoons.isEmpty {
            guard let moon = theMoons.popLast() else { continue }
            let newPairs = theMoons.map { [moon, $0] }
            moonPairs = moonPairs + newPairs
        }

        return moonPairs
    }
}
