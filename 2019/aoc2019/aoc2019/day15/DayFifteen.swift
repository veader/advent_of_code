//
//  DayFifteen.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/15/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DayFifteen: AdventDay {
    var dayNumber: Int = 15

    // func parse(_ input: String?) -> FOO { return FOO... }

    func partOne(input: String?) -> Any {
        let droid = RepairDroid(input: input ?? "")
        print("Starting Explore: \(Date())")
        droid.explore() // create map to search
        print("Starting Search: \(Date())")
        let shortestPath = droid.findShortestPath()
        print("Finished: \(Date())")
        return shortestPath
    }

    func partTwo(input: String?) -> Any {
        let droid = RepairDroid(input: input ?? "")
        print("Starting Explore: \(Date())")
        droid.explore() // create map to search
        print("Spreading Oxygen: \(Date())")
        let iterations = droid.fillMap()
        print("Finished: \(Date())")
        return iterations
    }
}
