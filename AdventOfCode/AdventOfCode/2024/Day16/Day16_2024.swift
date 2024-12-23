//
//  Day16_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/16/24.
//

import Foundation

struct Day16_2024: AdventDay {
    var year = 2024
    var dayNumber = 16
    var dayTitle = "Reindeer Maze"
    var stars = 1

    func parse(_ input: String?) -> ReindeerMaze? {
        ReindeerMaze(input: input ?? "")
    }

    func partOne(input: String?) async-> Any {
        guard let maze = parse(input) else { return -1 }
        return maze.crawlMaze()?.score ?? -1
    }

    func partTwo(input: String?) async -> Any {
//        guard let maze = parse(input) else { return -1 }
        return 0
    }
}
