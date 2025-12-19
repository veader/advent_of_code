//
//  Day12_2025.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/12/25.
//

import Foundation
import RegexBuilder

struct Day12_2025: AdventDay {
    var year = 2025
    var dayNumber = 12
    var dayTitle = "Christmas Tree Farm"
    var stars = 0

    struct PresentShape {
        let index: Int
        let shape: [[String]]
    }

    struct PresentRegion {
        let width: Int
        let height: Int
        let counts: [Int]
    }


    func parse(_ input: String?) -> ([PresentShape], [PresentRegion]) {
        let lines = (input ?? "").lines()

        var shapes = [PresentShape]()
        var regions = [PresentRegion]()

        var idx = 0
        while idx < lines.count {
            if let match = lines[idx].firstMatch(of: /^(\d+):/), let shapeIndex = Int(match.1) {
                let shapeLines = Array(lines[idx+1..<idx+4])
                let shape = PresentShape(index: shapeIndex, shape: shapeLines.map({ $0.map(String.init) }))
                shapes.append(shape)
                idx += 4
            } else if let match = lines[idx].firstMatch(of: /^(\d+)x(\d+):/), let width = Int(match.1), let height = Int(match.2) {
                let regionCounts = lines[idx].split(separator: " ").dropFirst().compactMap { Int($0) }
                let region = PresentRegion(width: width, height: height, counts: regionCounts)
                assert(regionCounts.count == shapes.count)
                regions.append(region)
                idx += 1
            } else {
                idx += 1
            }
        }

        return (shapes, regions)
    }

    func partOne(input: String?) -> Any {
        let (shapes, regions) = parse(input)
        return 0
    }

    func partTwo(input: String?) -> Any {
        let (shapres, regions) = parse(input)
        return 0
    }
}
