//
//  CaveNode.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/15/21.
//

import Foundation

class CaveNode {
    let location: Coordinate
    let cost: Int
    var minDistance: Int
    var shortedPath: [Coordinate]
    var visited: Bool

    init(location: Coordinate, cost: Int) {
        self.location = location
        self.cost = cost

        minDistance = Int.max // start with highest amount
        shortedPath = [Coordinate]()
        visited = false
    }

    /// Update this node's minimum distance and path, IF the given distance is less than what it is currently.
    ///
    /// - note: This method takes into account adding it's own cost and location to the given values.
    func update(distance: Int, path: [Coordinate]) {
        let newMinDistance = distance + cost
        guard newMinDistance < minDistance else { return }
        minDistance = newMinDistance
        shortedPath = path + [location]
    }

    /// Mark this node as visited.
    func markVisited() {
        visited = true
    }
}

extension CaveNode: Equatable {
    /// Are these the same node? For all practical purposes, we only care about the location.
    static func == (lhs: CaveNode, rhs: CaveNode) -> Bool {
        lhs.location == rhs.location
    }
}

extension CaveNode: Hashable {
    /// Hash based on location...
    func hash(into hasher: inout Hasher) {
        hasher.combine(location.x)
        hasher.combine(location.y)
    }
}

extension CaveNode: CustomDebugStringConvertible {
    var debugDescription: String {
        "CaveNode<location:\(location), cost:\(cost), min:\(minDistance), shortest:\(shortedPath), visited:\(visited ? "yes" : "no")>"
    }
}
