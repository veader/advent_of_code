//
//  DaySeven2022.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/7/22.
//

import Foundation

struct DaySeven2022: AdventDay {
    var year = 2022
    var dayNumber = 7
    var dayTitle = "No Space Left On Device"
    var stars = 2

    func partOne(input: String?) -> Any {
        let console = ElfConsole(output: input)
        console.run()
        // console.printFilesystem()

        let smallDirs = console.findDirectories(where: { $0.size <= 100000 })
        return smallDirs.map(\.size).reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        let console = ElfConsole(output: input)
        console.run()
        // console.printFilesystem()

        let unusedSpace = 70000000 - console.filesystem.size
        let neededSpace = 30000000 - unusedSpace

        let candidates = console.findDirectories(where: { $0.size >= neededSpace })
        let smallest = candidates.sorted(by: {$0.size < $1.size }).first

        return smallest?.size ?? 0
    }
}
