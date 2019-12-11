//
//  DayEleven.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/11/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DayEleven: AdventDay {
    var dayNumber: Int = 11

    func partOne(input: String?) -> Any {
        let robot = PaintingRobot(input: input ?? "")
        robot.run()
        return robot.paintedPanels.count
    }

    func partTwo(input: String?) -> Any {
        let robot = PaintingRobot(input: input ?? "")
        robot.startingColor = .white
        robot.run()
        return 0
    }
}
