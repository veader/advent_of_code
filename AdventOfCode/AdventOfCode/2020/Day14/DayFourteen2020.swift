//
//  DayFourteen.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/14/20.
//

import Foundation

struct DayFourteen2020: AdventDay {
    var year = 2020
    var dayNumber = 14
    var dayTitle = "Docking Data"
    var stars = 2

    func partOne(input: String?) -> Any {
        let dockingProgram = DockingProgram()
        dockingProgram.initialize(input)
        return dockingProgram.memorySum
    }

    func partTwo(input: String?) -> Any {
        let dockingProgram = DockingProgram()
        dockingProgram.initialize(input, version: 2)
        return dockingProgram.memorySum
    }
}
