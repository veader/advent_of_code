//
//  RelativeDirection.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/17/24.
//

import Foundation

/// Relative direction used when finding orientation between `Coordinates`.
///
/// - Note: Uses compass directions. `Coordinate` should understand movement based on
/// other factors like position of origin in the `GridMap`, etc
enum RelativeDirection: CaseIterable, Equatable {
    case north
    case northEast
    case east
    case southEast
    case south
    case southWest
    case west
    case northWest
    case same

    /// Provide the opposite to this direction?
    /// Example: North -> South
    var opposite: RelativeDirection {
        switch self {
        case .north:
            .south
        case .northEast:
            .southWest
        case .east:
            .west
        case .southEast:
            .northWest
        case .south:
            .north
        case .southWest:
            .northEast
        case .west:
            .east
        case .northWest:
            .southEast
        case .same:
            .same
        }
    }

    /// rotating direction 90º clockwise...
    var rotated90: RelativeDirection {
        switch self {
        case .north:
            .east
        case .northEast:
            .southEast
        case .east:
            .south
        case .southEast:
            .southWest
        case .south:
            .west
        case .southWest:
            .northWest
        case .west:
            .north
        case .northWest:
            .northEast
        case .same:
            .same
        }
    }

    /// rotating direction 90º counter-clockwise...
    var ccwRotation90: RelativeDirection {
        switch self {
        case .north:
            .west
        case .northEast:
            .northWest
        case .east:
            .north
        case .southEast:
            .northEast
        case .south:
            .east
        case .southWest:
            .southEast
        case .west:
            .south
        case .northWest:
            .southWest
        case .same:
            .same
        }
    }
}
