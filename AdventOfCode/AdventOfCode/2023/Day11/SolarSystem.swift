//
//  SolarSystem.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/12/23.
//

import Foundation

class SolarSystem {
    enum SpaceData: String, CustomDebugStringConvertible {
        case space = "."
        case galaxy = "#"

        var debugDescription: String { rawValue }
    }

    let spaceMap: GridMap<SpaceData>
    var galaxies: [Coordinate]

    init(_ input: String) {
        let data: [[SpaceData]] = input.lines().map { line in
            line.charSplit().compactMap { SpaceData(rawValue: $0) }
        }

        spaceMap = GridMap(items: data)
        galaxies = spaceMap.filter(by: { $1 == .galaxy })
    }


    // MARK: -

    /// Expand just the galaxy coordinates, not the map
    func expand(by amount: Int = 2) {
        let expansion = amount - 1

        let emptyCols = spaceMap.xBounds.compactMap { x -> Int? in
            guard let col = spaceMap.column(x: x) else { return nil }
            let set = Set(col)
            if set.contains(.space) && set.count == 1 {
                return x
            } else {
                return nil
            }
        }

        let emptyRows = spaceMap.yBounds.compactMap { y -> Int? in
            guard let row = spaceMap.row(y: y) else { return nil }
            let set = Set(row)
            if set.contains(.space) && set.count == 1 {
                return y
            } else {
                return nil
            }
        }

        // for any galaxy that is beyond an empty column or row, increase it's x/y values accordingly
        for (idx, g) in galaxies.enumerated() {
            let xMatches = emptyCols.filter({ $0 < g.x }).count
            let yMatches = emptyRows.filter({ $0 < g.y }).count
            galaxies[idx] = Coordinate(x: g.x + (xMatches * expansion), y: g.y + (yMatches * expansion))
        }
    }

    // Simplistic expansion based on updating the GridMap
    func simpleExpand() {
        let emptyCols = spaceMap.xBounds.compactMap { x -> Int? in
            guard let col = spaceMap.column(x: x) else { return nil }
            let set = Set(col)
            if set.contains(.space) && set.count == 1 {
                return x
            } else {
                return nil
            }
        }

        let emptyRows = spaceMap.yBounds.compactMap { y -> Int? in
            guard let row = spaceMap.row(y: y) else { return nil }
            let set = Set(row)
            if set.contains(.space) && set.count == 1 {
                return y
            } else {
                return nil
            }
        }

        for (factor, x) in emptyCols.sorted().enumerated() {
            spaceMap.insertColumn(at: x + factor, value: .space)
        }

        for (factor, y) in emptyRows.sorted().enumerated() {
            spaceMap.insertRow(at: y + factor, value: .space)
        }

        findGalaxies() // updated our stored galaxy coordinates
    }

    ///  Find and return the galaxies in the system. Updates any stored values.
    @discardableResult
    func findGalaxies() -> [Coordinate] {
        let updatedGalaxies = spaceMap.filter(by: { $1 == .galaxy }).sorted(by: { $0.y < $1.y && $0.x < $1.x })
        galaxies = updatedGalaxies
        return galaxies
    }

    /// Calculate the distances between the galaxies
    func calculateDistances() -> [Int] {
        let pairs: [[Coordinate]] = galaxies.enumerated().flatMap { idx, c -> [[Coordinate]] in
            guard galaxies.count > idx + 1 else { return [] }
            let theRest = galaxies.suffix(from: idx + 1)
            return theRest.map { [c, $0] }
        }

        return pairs.map { $0.first!.distance(to: $0.last!) }
    }

}
