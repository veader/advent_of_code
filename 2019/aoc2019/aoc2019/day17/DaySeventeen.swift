//
//  DaySeventeen.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/17/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DaySeventeen: AdventDay {
    var dayNumber: Int = 17

    func partOne(input: String?) -> Any {
        var robot = VacuumRobot(input: input ?? "")
        robot.run()
        robot.camera.printScreen()

        let intersections = robot.camera.intersections()
        let answer = intersections.reduce(0) {  $0 + ($1.x * $1.y) }
        return answer
    }

    func partTwo(input: String?) -> Any {
        let robot = VacuumRobot(input: input ?? "")
        robot.wakeUp()

        let commands = "A,B,B,A,C,A,C,A,C,B\n" +    // main command
                       "L,6,R,12,R,8\n" +           // A function
                       "R,8,R,12,L,12\n" +          // B function
                       "R,12,L,12,L,4,L,4\n" +      // C function
                       "n\n"                        // print mode (off)
        let ascii = commands.compactMap { $0.asciiValue }.map(Int.init)
        // print(ascii)
        robot.machine.inputs = ascii

        robot.run()

        return robot.machine.outputs.last ?? -1
    }
}
