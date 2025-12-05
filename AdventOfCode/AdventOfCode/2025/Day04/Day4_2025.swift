//
//  Day4_2025.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/4/25.
//

import Foundation

struct Day4_2025: AdventDay {
    var year = 2025
    var dayNumber = 4
    var dayTitle = "Printing Department"
    var stars = 2

    enum PaperItem: String, CustomDebugStringConvertible {
        case roll = "@"
        case empty = "."
        case removed = "x"

        var debugDescription: String {
            self.rawValue
        }
    }

    func parse(_ input: String?) -> GridMap<PaperItem> {
        let mapData: [[PaperItem]] = (input ?? "").lines().map { line in
            line.map(String.init).compactMap { PaperItem(rawValue: $0) }
        }
        return GridMap(items: mapData)
    }
    
    func partOne(input: String?) -> Any {
        let map = parse(input)

        let accessibleRolls = map.filter { coordinate, item in
            isRollMovable(location: coordinate, map: map)
        }

        return accessibleRolls.count
    }
    
    func partTwo(input: String?) -> Any {
        let map = parse(input)
        return removeRolls(map)
    }

    func removeRolls(_ map: GridMap<PaperItem>) -> Int {
        // IDEA: The top row spaces can have *at most* 5 adjacent rolls.
        //      * The origin can only have 3, max.
        //      * If we move from origin to the right (assuming we remove the one to the left), that means the possibility is just 4 max.
        //      * Making another pass to see if removing the previous pass made any more removable on the row
        //      * Then each subsequent row looks "similar" to the top row...
        //      * Loop over the map again (assuming we removed anything on the last pass)

        var outerLoopRemovals = 0
        repeat {
            outerLoopRemovals = 0 // clear for the run

            for (y, row) in map.rows.enumerated() {
                var rowRemovals = 0

                repeat {
                    rowRemovals = 0 // clear for the run

                    for x in row.indices {
                        let coordinate = Coordinate(x: x, y: y)
                        if isRollMovable(location: coordinate, map: map) {
                            map.update(at: coordinate, with: .removed) // mark it as removed
                            rowRemovals += 1 // track that we actually removed something
                        }
                    }

//                    map.printGrid()
//                    print("\n")

                    outerLoopRemovals += rowRemovals // track how many we've removed
                } while rowRemovals > 0
            }
        } while outerLoopRemovals > 0

        return map.count(where: { $0 == .removed })
    }

    /// A roll is movable if it has no more than 4 adjacent rolls.
    private func isRollMovable(location: Coordinate, map: GridMap<PaperItem>) -> Bool {
        let item = map.item(at: location)
        guard item == .roll else { return false } // not even a roll

        let adjacent = map.adjacentCoordinates(to: location, allowDiagonals: true)
        let adjacentRolls = adjacent.filter { map.item(at: $0) == .roll }
        return adjacentRolls.count < 4
    }
}
