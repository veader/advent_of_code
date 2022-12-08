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
    var stars = 0

// 392,132
    func partOne(input: String?) -> Any {
        let console = ElfConsole(output: input)
        console.run()
        console.printFilesystem()
        console.calculateSizeMap()

        let smallDirs = console.directorySizeMap.filter { name, size in
            size <= 100000
        }

        return smallDirs.values.reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
