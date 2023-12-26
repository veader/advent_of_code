//
//  CityBlock.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/20/23.
//

import Foundation

class CityBlock {
    let location: Coordinate
    let cost: Int
    var minDistance: Int
    var shortedPath: [Coordinate]
    var visited: Bool
    var trackPath: Bool

    init(location: Coordinate, cost: Int, trackPath: Bool = true) {
        self.location = location
        self.cost = cost
        self.trackPath = trackPath

        minDistance = Int.max // start with highest amount
        shortedPath = [Coordinate]()
        visited = false
    }

    /// Update this block's minimum distance and path, IF the given distance is less than what it is currently.
    ///
    /// - Note: This method takes into account adding it's own cost and location to the given values.
    func update(distance: Int, path: [Coordinate], straightLimit: Int = 3) -> Bool {
        let newMinDistance = distance + cost

        // confirm distance IS shorter
        guard newMinDistance < minDistance else { return true }

        // check on straight line condition
//        let suffix = path.suffix(straightLimit)
//        if suffix.count == straightLimit { // we need at least this many to do the check
//            print("\t\t\(suffix)")
//            // we are going "straight" if either the x or y hasn't changed
//            let xs = suffix.map(\.x).unique()
//            let ys = suffix.map(\.y).unique()
//            if xs.count == 1, xs.first == location.x {
//                print("\t\tIgnoring \(location)")
//                return false
//            } else if ys.count == 1, ys.first == location.y {
//                print("\t\tIgnoring \(location)")
//                return false
//            }
//        }

        print("\t\tUpdating: \(minDistance) -> \(newMinDistance)")
        // no objections? update new min distance and path
        minDistance = newMinDistance

        if trackPath {
            shortedPath = path + [location]
        }

        return true
    }

    /// Mark this block as visited.
    func markVisited() {
        visited = true
    }
}
