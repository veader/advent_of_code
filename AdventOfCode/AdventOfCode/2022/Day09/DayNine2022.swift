//
//  DayNine2022.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/9/22.
//

import Foundation

struct DayNine2022: AdventDay {
    var year = 2022
    var dayNumber = 9
    var dayTitle = "Rope Bridge"
    var stars = 1

    func partOne(input: String?) -> Any {
        let sim = RopeSimulator(input ?? "")
        sim.run()
        sim.printIteration()
        sim.printIteration(showingVisited: true)
        return sim.visitedCoordinates.count
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
