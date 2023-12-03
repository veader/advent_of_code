//
//  Day3_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/3/23.
//

import Foundation
import RegexBuilder

struct Day3_2023: AdventDay {
    var year = 2023
    var dayNumber = 3
    var dayTitle = "Gear Ratios"
    var stars = 1

    struct GondolaPart: CustomDebugStringConvertible {
        let partNumber: Int
        let coordinates: [Coordinate]

        public var debugDescription: String { "Part(\(partNumber) @ \(coordinates))" }
    }

    struct GondolaSymbol: CustomDebugStringConvertible {
        let symbol: String
        let coordinate: Coordinate

        public var debugDescription: String { "Symbol(\(symbol) @ \(coordinate))" }
    }

    func parse(_ input: String?, translate: Bool = false) -> ([GondolaPart], [GondolaSymbol]) {
        // parse the grid
        // - find any part numbers and gather up whole number and all the coordinates it occupies
        // - find any symbol and record it's location
        var parts = [GondolaPart]()
        var symbols = [GondolaSymbol]()

        let lines = (input ?? "").split(separator: "\n").map(String.init)
        for (y, line) in lines.enumerated() {
            var currentPart: String = "" // collect numbers here
            var currentPartCoords: [Coordinate] = []

            for (x, char) in line.enumerated() {
                if let _ = String(char).firstMatch(of: /\d/) {
                    // append to currently building number
                    currentPart.append("\(char)")
                    currentPartCoords.append(Coordinate(x: x, y: y))
                } else {
                    // if we encounter a space or symbole, save any current number and reset it
                    if let partNum = Int(currentPart) {
                        let part = GondolaPart(partNumber: partNum, coordinates: currentPartCoords)
                        parts.append(part)
                    }
                    currentPart = ""
                    currentPartCoords = []

                    if char != "." {
                        let symbol = GondolaSymbol(symbol: "\(char)", coordinate: Coordinate(x: x, y: y))
                        symbols.append(symbol)
                    }
                }
            }

            // take care of any part we're building at the end of aline
            if let partNum = Int(currentPart) {
                let part = GondolaPart(partNumber: partNum, coordinates: currentPartCoords)
                parts.append(part)
            }
        }

        return (parts, symbols)
    }

    func partOne(input: String?) -> Any {
        let (parts, symbols) = parse(input)
        let symbolCoordinates = Set(symbols.map(\.coordinate))

        let validParts = parts.filter { part in
            // get all of the coordinates around a given part
            let partCoords = Set(part.coordinates)
            let adjacentCoords = Set(part.coordinates.flatMap({ $0.adjacent() })).subtracting(partCoords)
            let intersection = symbolCoordinates.intersection(adjacentCoords)

            // a valid part will have at least one coordinate near a symbol
            return !(intersection.isEmpty)
        }

        return validParts.map(\.partNumber).reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        0
    }
}
