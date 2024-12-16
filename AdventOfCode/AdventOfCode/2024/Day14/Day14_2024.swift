//
//  Day14_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/14/24.
//

import Foundation
import RegexBuilder

struct Day14_2024: AdventDay {
    var year = 2024
    var dayNumber = 14
    var dayTitle = "Restroom Redoubt"
    var stars = 1

    func parse(_ input: String?) -> [BathroomBot] {
        (input ?? "").lines().compactMap(BathroomBot.init)
    }

    func partOne(input: String?) async-> Any {
        let bots = parse(input)
        let bathroom = BathroomSimulator(bots: bots, width: 101, height: 103)
        await bathroom.tick(seconds: 100)
        return bathroom.safetyFactor()
    }

    func partTwo(input: String?) async -> Any {
        return 0
//        let bots = parse(input)
//        let bathroom = BathroomSimulator(bots: bots, width: 101, height: 103)
//        bathroom.shouldPrint = true
//        await bathroom.tick(seconds: 10000)
//        return bathroom.safetyFactor()
    }
}
