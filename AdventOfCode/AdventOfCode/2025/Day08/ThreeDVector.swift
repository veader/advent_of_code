//
//  ThreeDVector.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/9/25.
//

import Foundation

/// A 3D vector which has a start and end and a calculated distance.
struct ThreeDVector: Equatable, Comparable {
    let start: ThreeDCoordinate
    let end: ThreeDCoordinate
    let distance: Float

    init(start: ThreeDCoordinate, end: ThreeDCoordinate) {
        self.start = start
        self.end = end
        self.distance = start.distance(to: end)
    }

    static func == (lhs: ThreeDVector, rhs: ThreeDVector) -> Bool {
        (lhs.start == rhs.start && lhs.end == rhs.end) ||
        (lhs.start == rhs.end && lhs.end == rhs.start)
    }

    static func < (lhs: ThreeDVector, rhs:ThreeDVector) -> Bool {
        lhs.distance < rhs.distance
    }
}
