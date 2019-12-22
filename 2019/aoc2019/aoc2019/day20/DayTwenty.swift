//
//  DayTwenty.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/20/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DayTwenty: AdventDay {
    var dayNumber: Int = 20

    // func parse(_ input: String?) -> FOO { return FOO... }

    func partOne(input: String?) -> Any {
        let maze = DonutMaze(input: input ?? "")
        print("Start: \(Date())")
        let answer = maze.shortestPath()
        print("End: \(Date())")
        return answer
    }

    func partTwo(input: String?) -> Any {
        let maze = DonutMaze(input: input ?? "")
        print("Start: \(Date())")
        let answer = maze.shortestPath(recursive: true)
        print("End: \(Date())")
        return answer
    }
}
