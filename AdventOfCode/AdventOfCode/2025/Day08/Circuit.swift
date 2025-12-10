//
//  Circuit.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/9/25.
//

import Foundation

/// A circuit is a collection of connected 3D points
class Circuit: Equatable {
    var root: ThreeDCoordinate?
    var points: Set<ThreeDCoordinate>

    init(points: [ThreeDCoordinate]) {
        self.points = Set<ThreeDCoordinate>(points)
        self.root = points.first
    }

    init(points: Set<ThreeDCoordinate>) {
        self.points = points
        self.root = points.first
    }

    func insert(_ point: ThreeDCoordinate) {
        points.insert(point)
    }

    func insert(points newPoints: Set<ThreeDCoordinate>) {
        points.formUnion(newPoints)
    }

    func contains(point: ThreeDCoordinate) -> Bool {
        points.contains(point)
    }

    func contains(_ vector: ThreeDVector) -> Bool {
        points.contains(vector.start) && points.contains(vector.end)
    }

    func partiallyContains(_ vector: ThreeDVector) -> Bool {
        points.contains(vector.start) || points.contains(vector.end)
    }

    /// Circuits are equal if they have the same points (ignoring the root, for now)
    static func == (lhs: Circuit, rhs: Circuit) -> Bool {
        lhs.points == rhs.points
    }
}
