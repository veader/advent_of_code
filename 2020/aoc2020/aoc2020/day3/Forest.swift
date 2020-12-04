//
//  Forest.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/3/20.
//

import Foundation

struct Forest {
    enum Space: String {
        case empty = "."
        case tree = "#"
    }

    struct Slope {
        let rise: Int
        let run: Int
    }

    let map: [[Space]]

    init?(_ input: String?) {
        guard let input = input else { return nil }
        map = input.split(separator: "\n").map {        // String -> [String]
            Array($0)                                   // String -> [Character]
                .map(String.init)                       // [Character] -> [String]
                .compactMap { Space(rawValue: $0) }     // [String] -> [Space]
        }

    }

    /// Width of the map (ie: width of a given row - first used)
    var mapWidth: Int {
        // TODO: how do we handle if we have rows that aren't equal widths?
        map[0].count
    }

    /// Height of the map (ie: number of rows)
    var mapHeight: Int {
        map.count
    }

    /// Return the Space at the given coordinate.
    ///
    /// Uses the width repeating logic to go past actual map width.
    /// `nil` is returned if `y` is outside of height of map.
    func at(x: Int, y: Int) -> Space? {
        guard map.indices.contains(y) else { return nil }

        let adjustedX = x % mapWidth
        return map[y][adjustedX]
    }

    func at(coordinate: Coordinate) -> Space? {
        at(x: coordinate.x, y: coordinate.y)
    }

    /// Travel down the given slope and track where we traveled and what we encountered...
    ///
    /// - returns: Tuple with path (in `[Coordinate]`) and spaces encountered (in `[Space]`)
    func travel(slope: Slope) -> (path: [Coordinate], spaces: [Space]) {
        var path = [Coordinate]()
        var spaces = [Space]()

        var coord = Coordinate(x: 0, y: 0) // start at the top left
        path.append(coord)
        spaces.append(at(coordinate: coord) ?? .empty)

        // travel down the given slope to the bottom of the "hill" (the map)
        while(coord.y < mapHeight) {
            coord = coord.moving(xOffset: slope.run, yOffset: slope.rise)

            guard let space = at(coordinate: coord) else {
                // print("Uh oh! \(coord) isn't valid...")
                break
            }

            path.append(coord)
            spaces.append(space)
        }

//        print(path)
//        print(spaces)

        return (path, spaces)
    }

    /// How many trees do we impact when traveling along a slope?
    func impacts(traveling slope: Slope) -> Int {
        let path = travel(slope: slope)
        return path.spaces.filter({ $0 == .tree }).count
    }

    ///
    func printTrip(slope: Slope) {
        let trip = travel(slope: slope)
        let maxX = trip.path.map({ $0.x }).max() ?? mapWidth

        var output = [String]()

        for y in 0..<map.count {
            var row = ""
            for x in 0..<(maxX + 1) {
                let coord = Coordinate(x: x, y: y)
                let space = at(coordinate: coord)
                if trip.path.contains(coord) {
                    switch space {
                    case .empty:
                        row.append("O")
                    case .tree:
                        row.append("X")
                    default:
                        row.append("_")
                    }
                } else {
                    row.append(space?.rawValue ?? " ")
                }
            }
            output.append(row)
        }

        print(output.joined(separator: "\n"))

    }

    /// Print map with a given width (defaults to 1) for debugging...
    func printMap(width: Int = 1) {
        var output = [String]()

        for y in 0..<map.count {
            var row = ""
            for x in 0..<(mapWidth * width) {
                row.append(at(x: x, y: y)?.rawValue ?? " ")
            }
            output.append(row)
        }

        print(output.joined(separator: "\n"))
    }
}
