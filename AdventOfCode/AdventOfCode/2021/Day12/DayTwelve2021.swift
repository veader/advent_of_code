//
//  DayTwelve2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/12/21.
//

import Foundation

struct DayTwelve2021: AdventDay {
    var year = 2021
    var dayNumber = 12
    var dayTitle = "Passage Pathing"
    var stars = 1

    func parse(_ input: String?) -> [CavePath] {
        (input ?? "").split(separator: "\n").map(String.init).compactMap { CavePath($0) }
    }

    func partOne(input: String?) -> Any {
        let map = CaveMap(paths: parse(input))
        let paths = map.findAllPaths()

        paths.sorted(by: { $0.count < $1.count }).forEach { path in
            print(path.joined(separator: ","))
        }

        return paths.count
    }

    func partTwo(input: String?) -> Any {
        return Int.min
    }
}
