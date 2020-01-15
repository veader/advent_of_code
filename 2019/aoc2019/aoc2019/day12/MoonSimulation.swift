//
//  MoonSimulation.swift
//  aoc2019
//
//  Created by Shawn Veader on 1/15/20.
//  Copyright © 2020 Shawn Veader. All rights reserved.
//

import Foundation

class MoonSimulation {
    let moons: [Moon]
    let pairs: [[Moon]]

    var totalEnergy: Int {
        moons.reduce(0) { $0 + $1.totalEnergy }
    }

    init(moons: [Moon]) {
        self.moons = moons
        self.pairs = MoonSimulation.createPairs(moons: moons)
    }

    func step(count: Int = 1, shouldPrint: Bool = false) {
        (0..<count).forEach { iteration in
            // first we apply gravity
            for pair in pairs {
                pair[0].applyGravity(toward: pair[1])
            }

            // next we apply velocity
            for moon in moons {
                moon.applyVelocity()
            }

            if shouldPrint {
                print("[\(iteration+1)] :\(stepDescription())")
            }
        }
    }

    func calculateCycles() -> (x: Int, y: Int, z: Int) {
        var xCycle: Int?
        var yCycle: Int?
        var zCycle: Int?

        let initialXs = moons.map { $0.position.x }
        let initialYs = moons.map { $0.position.y }
        let initialZs = moons.map { $0.position.z }

        print("Initial:\(stepDescription())")

        var cycleCount = 0

        while xCycle == nil || yCycle == nil || zCycle == nil {
            step()
            cycleCount += 1

            // if we haven't found a cycle already, check the current state
            //  against initial in each dimension to determine cycle time

            if xCycle == nil {
                let currentXs = moons.map { $0.position.x }
                if currentXs == initialXs {
                    print("X Repeat \(cycleCount):\(stepDescription())")
                    xCycle = cycleCount + 1
                }
            }

            if yCycle == nil {
                let currentYs = moons.map { $0.position.y }
                if currentYs == initialYs {
                    print("Y Repeat \(cycleCount):\(stepDescription())")
                    yCycle = cycleCount + 1
                }
            }

            if zCycle == nil {
                let currentZs = moons.map { $0.position.z }
                if currentZs == initialZs {
                    print("Z Repeat \(cycleCount):\(stepDescription())")
                    zCycle = cycleCount + 1
                }
            }
        }

        return (x: xCycle ?? 0, y: yCycle ?? 0, z: zCycle ?? 0)
    }

    private static func createPairs(moons: [Moon]) -> [[Moon]] {
        var theMoons = moons // copy so we can mutate it
        var moonPairs = [[Moon]]()

        while !theMoons.isEmpty {
            guard let moon = theMoons.popLast() else { continue }
            let newPairs = theMoons.map { [moon, $0] }
            moonPairs = moonPairs + newPairs
        }

        return moonPairs
    }

    func stepDescription() -> String {
        moons.reduce("") { $0 + " | \($1.shortDescription)" } + " |"
    }
}
