//
//  DayFourteen.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/14/20.
//

import Foundation

struct DayFourteen: AdventDay {
    var dayNumber: Int = 14

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
