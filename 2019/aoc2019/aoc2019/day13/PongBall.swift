//
//  PongBall.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/13/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct PongBall {
    /// Current location of the ball on the grid
    var position: Coordinate

    /// Slope describing the direction and angle of travel of the ball
    var slope: Coordinate.SlopeType


    /// Locations where a bounce occured
    var bounces: [Coordinate] = [Coordinate]()

    /// Steps taken along the calculated path
    var pathSteps: [Coordinate] = [Coordinate]()

    /// Blocks that are removed as we bounce
    var removedBlocks: [Coordinate] = [Coordinate]()

    let bounceDepth = 8
    let pathLength = 100


    /// Attempt to calculate where we would could impact the paddle if we bounce around enough.
    mutating func find(paddle: Coordinate, screen: ArcadeScreen) -> Coordinate? {
        var pathLocation = position
        var pathSlope = slope

        /// keep going until we are about to pass the paddle
        while pathLocation.y < (paddle.y - 1) &&
            bounces.count < bounceDepth &&
            pathSteps.count < pathLength
        {
            pathSteps.append(pathLocation)

            // update our slope and record any bounces we make changing it
            pathSlope = updateSlope(position: pathLocation, slope: pathSlope, screen: screen)

            // calculate next step and loop
            pathLocation = pathLocation.next(on: pathSlope)
        }

        // make sure that final step is included
        if let last = pathSteps.last, last != pathLocation {
            pathSteps.append(pathLocation)
        }

        return pathLocation
    }

    /// Update the slope value if this position is a bounce point.
    ///
    /// Records bounce point in the process.
    /// - returns: Slope (adjusted as needed)
    mutating func updateSlope(position: Coordinate,
                              slope: Coordinate.SlopeType,
                              screen: ArcadeScreen) -> Coordinate.SlopeType {

        // because of the origin of the grid system being top-left,
        //      our up and down are backwards
        //
        //  slope: 1   |  slope:-1
        //  dir: down  |  dir: down
        //  -----------+-----------
        //  slope:-1   |  slope: 1
        //  dir: up    |  dir: up

        guard // nothing but diagonal slopes here...
            case .normal(slope: let slopeValue, direction: let direction) = slope
            else { return slope }

        let diagonalLocation = position.next(on: slope)
        let horizontalLocation = horizontal(location: position, slope: slope)
        let verticalLocation = vertical(location: position, slope: slope)

        if screen.solid(at: horizontalLocation) && !removedBlocks.contains(horizontalLocation) {
            bounces.append(position)
            removedBlocks.append(horizontalLocation)
            return .normal(slope: slopeValue * -1, direction: direction)
        }
        if screen.solid(at: verticalLocation) && !removedBlocks.contains(verticalLocation) {
            bounces.append(position)
            removedBlocks.append(verticalLocation)
            return .normal(slope: slopeValue * -1, direction: direction * -1)
        }
        if screen.solid(at: diagonalLocation) && !removedBlocks.contains(diagonalLocation) {
            bounces.append(position)
            removedBlocks.append(diagonalLocation)
            return .normal(slope: slopeValue, direction: direction * -1)
        }

        return slope // keep going the way we're going
    }

    /// Location either up or down from the given location in the direction of travel
    private func vertical(location: Coordinate, slope: Coordinate.SlopeType) -> Coordinate {
        guard // nothing but diagonal slopes here...
            case .normal(slope: _, direction: let direction) = slope
            else { return Coordinate.origin }

        if direction == -1 {
            return location.up
        } else if direction == 1 {
            return location.down
        }

        return Coordinate.origin
    }

    /// Location either left or right from the given location in the direction of travel
    private func horizontal(location: Coordinate, slope: Coordinate.SlopeType) -> Coordinate {
        guard // nothing but diagonal slopes here...
            case .normal(slope: let slopeValue, direction: let direction) = slope
            else { return Coordinate.origin }

        if slopeValue == 1 && direction == 1 {
            // heading down and to the right
            return location.right
        } else if slopeValue == 1 && direction == -1 {
            // heading up and to the left
            return location.left
        } else if slopeValue == -1 && direction == 1 {
            // heading down and to the left
            return location.left
        } else if slopeValue == -1 && direction == -1 {
            // heading up and to the right
            return location.right
        }

        return Coordinate.origin
    }
}

extension Coordinate {
    // NOTE: these methods have up/down direction mixed... 'cause

    var up: Coordinate {
        Coordinate(x: self.x, y: self.y - 1)
    }

    var down: Coordinate {
        Coordinate(x: self.x, y: self.y + 1)
    }

    var left: Coordinate {
        Coordinate(x: self.x - 1, y: self.y)
    }

    var right: Coordinate {
        Coordinate(x: self.x + 1, y: self.y)
    }
}
