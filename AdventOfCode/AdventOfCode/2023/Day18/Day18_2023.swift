//
//  Day18_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/25/23.
//

import Foundation
import RegexBuilder

struct Day18_2023: AdventDay {
    var year = 2023
    var dayNumber = 18
    var dayTitle = "Lavaduct Lagoon"
    var stars = 0


    func parse(_ input: String?) -> [DiggingInstruction] {
        return (input ?? "").lines().compactMap(DiggingInstruction.init)
    }

    func partOne(input: String?) async -> Any {
        let instructions = parse(input)
        let digMap = DigMap(instructions: instructions)

//        var current: Coordinate = .origin // starting coordinate
//        var coordinates: Set<Coordinate> = [current]
//
//        for inst in instructions {
//            let relDir = inst.direction.direction
//            for _ in (0..<inst.distance) {
//                current = current.moving(direction: relDir, originTopLeft: true)
//                coordinates.insert(current)
//            }
//        }
//
////        print(coordinates)
//        print(coordinates.count)

        
//        for y in grid.yBounds {
//            var row = (grid.row(y: y) ?? []).joined()
//            row = row.trimmingCharacters(in: ["."])
//            print(row)
//        }
         

//        var rowMap: [Int: [Coordinate]] = [:]
//        for c in coordinates {
//            var row = rowMap[c.y] ?? []
//            row.append(c)
//            rowMap[c.y] = row
//        }
//
//        for y in rowMap.keys.sorted() {
//            guard let row = rowMap[y] else { continue }
//            let sorted = row.sorted(by: { $0.x < $1.x })
//            print("\(y) has \(row.count) coordinates")
//            print("\t\(sorted)")
//        }

        return 0
    }

    func partTwo(input: String?) async -> Any {
        return 0
    }
}
