//
//  DayTwenty2021.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/21/21.
//

import Foundation

struct DayTwenty2021: AdventDay {
    var year = 2021
    var dayNumber = 20
    var dayTitle = "Trench Map"
    var stars = 2

    func parse(_ input: String?) -> TrenchMap {
        var lines = (input ?? "").split(separator: "\n").map(String.init)
        let decoder = lines.removeFirst().compactMap { TrenchMap.BinaryPixel.parse(String($0)) }
//        _ = lines.removeFirst() // remove blank line between decoder and map

        let mapping = lines.map { line in
            line.compactMap { TrenchMap.BinaryPixel.parse(String($0)) }
        }

        let grid = GridMap<TrenchMap.BinaryPixel>(items: mapping)

        let litPixelCoordinates = grid.filter { coordinate, pixel in
            guard case .lit = pixel else { return false }
            return true
        }

        return TrenchMap(decoder: decoder, litPixels: Set<Coordinate>(litPixelCoordinates))
    }


    func partOne(input: String?) -> Any {
        let trenchMap = parse(input)
        print("Initial:")
        trenchMap.printImage()
        print("    ")

        trenchMap.enhanceImage(count: 2)
        trenchMap.printImage()
        print("    ")

        return trenchMap.litPixels.count
    }

    func partTwo(input: String?) -> Any {
        let trenchMap = parse(input)
        print("Initial:")
        trenchMap.printImage()
        print("    ")

        trenchMap.enhanceImage(count: 50)
        trenchMap.printImage()
        print("    ")

        return trenchMap.litPixels.count
    }
}
