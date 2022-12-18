//
//  DayFourteen2022.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/16/22.
//

import Foundation

struct DayFourteen2022: AdventDay {
    var year = 2022
    var dayNumber = 14
    var dayTitle = "Regolith Reservoir"
    var stars = 2

    func partOne(input: String?) -> Any {
        let paths = SandSim.parse(input ?? "")
        let sim = SandSim(paths: paths)
        let answer = sim.run()
//        sim.printScan()
        return answer
    }

    func partTwo(input: String?) -> Any {
        let paths = SandSim.parse(input ?? "")
        let sim = SandSim(paths: paths)
        let answer = sim.run(floor: true)
//        sim.printScan(floor: true)
        return answer
    }
}
