//
//  GuardPatrol.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/6/24.
//

import Foundation

class GuardPatrol {
    let map: GridMap<String>

    var guardStartingPosition: Coordinate? = .origin
    var guardCurrentPosition: Coordinate = .origin
    var guardOrientation: Coordinate.RelativeDirection = .north

    init(map: GridMap<String>) {
        self.map = map

        // find position of guard
        if let position = map.first(where: { $0 == "^" }) {
            guardStartingPosition = position
            guardCurrentPosition = position
        }
    }

    /// Follow the guard on patrol.
    /// - returns: Coordinates the guard has visited
    func followGuard() -> [Coordinate] {
        // TODO: if we are starting over and updating the guard position along the way,
        // we need to put the guard back to the starting position & orientation

        var visitedPositions: Set<Coordinate> = []

        while map.valid(coordinate: guardCurrentPosition) {
            visitedPositions.insert(guardCurrentPosition)

            // determine next position
            var nextPosition = guardCurrentPosition.moving(direction: guardOrientation, originTopLeft: true)

            // determine if we need to rotate based on obstacle ahead
            while isObstacleAt(nextPosition) {
//                print("Rotating because of obstacle at \(nextPosition)")
                // rotate guard
                guardOrientation = guardOrientation.rotated90

                // determine next position
                nextPosition = guardCurrentPosition.moving(direction: guardOrientation, originTopLeft: true)
            }

            // TODO: Update map to follow guard around?

            // take a step
            guardCurrentPosition = nextPosition
        }

        return visitedPositions.map(\.self)
    }

    func isObstacleAt(_ coordinate: Coordinate) -> Bool {
        return map.item(at: coordinate) == "#"
    }
}
