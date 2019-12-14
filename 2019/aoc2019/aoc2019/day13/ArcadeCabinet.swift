//
//  ArcadeCabinet.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/13/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

class ArcadeCabinet {
    let screen: ArcadeScreen
    let machine: IntCodeMachine
    var score: Int = 0

    var previousBallLocation: Coordinate? = nil

    enum JoystickOrientation: Int {
        case neutral = 0
        case left = -1
        case right = 1
    }

    enum BounceDirection: Equatable {
        case up
        case left
        case right
        case down
        case diagonal
        case none

        var text: String {
            switch self {
            case .up:
                return "up"
            case .down:
                return "down"
            case .left:
                return "left"
            case .right:
                return "right"
            case .diagonal:
                return "diagonal"
            case .none:
                return "none"
            }
        }
    }


    init(input: String) {
        machine = IntCodeMachine(instructions: input)
        machine.silent = true
        machine.store(value: 2, at: 0) // free play

        screen = ArcadeScreen()
    }

    /// Play the game...
    func play() {
        var finished = false

        // start the machine running
        machine.run()

        var waitCount = 1000

        while !finished {
            if case .finished(output: _) = machine.state {
                finished = true
            } else if case .awaitingInput = machine.state {
                print("")

                processMachineOutputs()

                print("Score: \(score)")
                screen.printScreen()

                let move = calculateMove()
                print("Joystick input: \(move)")
                machine.set(input: move.rawValue)

                waitCount -= 1
                if waitCount == 0 {
                    exit(1)
                }
            } else {
                // print(".")
            }
        }
    }

    func calculateMove() -> JoystickOrientation {
        // find the ball
        // find the paddle
        // determine ball's path
        // if away from us: joystick -> neutral
        // if toward us: calculate where paddle should be to intersect
        //      determine how many steps away we are from there
        //      if not there
        //          - move toward that location (joystick -> left/right)
        //      else
        //          - joystick -> neutral

        guard
            let prevLocation = previousBallLocation,
            let currentLocation = screen.ballLocation,
            let paddleLocation = screen.paddleLocation
            else {
                previousBallLocation = screen.ballLocation
                return .neutral
            }

        var output: JoystickOrientation = .neutral

        print("=========================================")
        print("Paddle @ \(paddleLocation)")

        // find the slope of travel for the ball
        // REMEMBER: down is up and up is down, because of top-left origin
        let slope = prevLocation.slope(to: currentLocation)

        var pongBall = PongBall(position: currentLocation, slope: slope)
        if let intersection = pongBall.find(paddle: paddleLocation, screen: screen) {
            print("Hit paddle @ \(intersection)")
            print("")
            screen.printPath(of: pongBall)

            let ballHeight = intersection.y - currentLocation.y
            let ballDelta = abs(currentLocation.x - intersection.x)
            print("Ball height: \(ballHeight), delta: \(ballDelta)")
            if ballHeight - 2 > ballDelta {
                // attempt to favor towards middle, just in case
                print("Favoring middle...")
                let center = screen.centerX

                if paddleLocation.x < center {
                    output = .right
                } else if paddleLocation.x > center {
                    output = .left
                }
            } else {
                // head towards point of intersection
                if paddleLocation.x < intersection.x {
                    output = .right
                } else if paddleLocation.x > intersection.x {
                    output = .left
                }
            }
        }

        /*
        if case .normal(slope: _, direction: let direction) = slope {
            if let bounce = followTheBouncing(ball: currentLocation, paddle: paddleLocation, slope: slope) {
                print("Ball @ \(currentLocation) should bounce once it hits: \(bounce.0), updating slope: \(bounce.1)")
                output = joystickOrientation(ball: bounce.0, paddle: paddleLocation, slope: bounce.1)
            } else {
                if direction == -1 { // ball is traveling up towards blocks
                } else if direction == 1 { // ball is traveling down toward paddle
                    // determine how we should move to get to the impact point
                    output = joystickOrientation(ball: currentLocation, paddle: paddleLocation, slope: slope)
                }
            }
        }
         */

        // store the last place we saw the ball for next loop
        previousBallLocation = currentLocation

        return output
    }

    func joystickOrientation(ball: Coordinate, paddle: Coordinate, slope: Coordinate.SlopeType) -> JoystickOrientation {
        if let goal = pointOfImpact(ball: ball, paddle: paddle, slope: slope) {
            let distance = paddle.x - goal.x
            if distance < 0 {
                print("Moving right... \(goal) \(paddle)")
                return .right
            } else if distance > 0 {
                print("Moving left... \(goal) \(paddle)")
                return .left
            }
        } else {
            print("Unable to find point of impact. ball:\(ball) paddle:\(paddle)")
        }

        return .neutral
    }

    /// Determine the next point of impact for a ball on a given trajectory...
    func pointOfImpact(ball: Coordinate, paddle: Coordinate, slope: Coordinate.SlopeType) -> Coordinate? {
        // to "hit" paddle, the paddle must have the same X coordinate as
        //      as the ball when the ball's y coordinate is paddle's y - 1

        // is the ball at the point of impact?
        guard ball.y != paddle.y - 1 && ball.x != paddle.x else { return ball }

        guard
            ball.y < paddle.y,
            case .normal(slope: _, direction: let slopeDirection) = slope,
            slopeDirection == 1
            else { return nil }

        var loopCount = 0 // let's be reasonable about this...
        var impactPoint: Coordinate = ball.next(on: slope)
        while impactPoint.y != paddle.y - 1 {
            impactPoint = impactPoint.next(on: slope)
            loopCount += 1

            guard loopCount < 100 else { print("Hit loop end"); return nil }
        }

        return impactPoint
    }

    typealias Bounce = (Coordinate, Coordinate.SlopeType)

    /// Follow a ball as it bounces around until it is headed toward the paddle (or out of bounds)...
    func followTheBouncing(ball: Coordinate, paddle: Coordinate, slope: Coordinate.SlopeType) -> Bounce? {
        var lastBounce: Bounce = (ball, slope) // if all else fails...
        var bounceLevel = 0

        var bounceDetected = nextBouncePoint(ball: ball, paddle: paddle, slope: slope)
        while bounceDetected != nil {
            print("Found bounce: \(bounceDetected?.0) \(bounceDetected?.1)")

            if let bounce = bounceDetected {
                guard bounce.0 != lastBounce.0 else {
                    if ball == bounce.0 {
                        // ball is likely at the point of impact, give the proper bounce since this has the right slope
                        lastBounce = bounce
                    }
                    break
                }

                lastBounce = bounce
                bounceDetected = nextBouncePoint(ball: bounce.0, paddle: paddle, slope: bounce.1)
            }

            bounceLevel += 1
            if bounceLevel > 1 {
                print("Bounce Level: \(bounceLevel)...")
            }
        }

        return lastBounce
    }

    /// Find the point where the given ball impacts a surface along it's current path.
    /// - returns: Optional tuple describing point of bounce and new slope (based on direction of impact)
    func nextBouncePoint(ball: Coordinate, paddle: Coordinate, slope: Coordinate.SlopeType) -> Bounce? {
        // while not traveling beyond the y plane of the paddle,
        //      follow the current path of the ball till we encounter a block or wall
        guard case .none = isObstacle(beside: ball) else {
            let direction = isObstacle(beside: ball)
            return (ball, update(slope: slope, hitting: direction))
        }

        var point: Coordinate = ball
        var nextPoint: Coordinate = point.next(on: slope)

        if screen.solid(at: nextPoint) {
            // we've diagonally encountered something
            let newSlope = update(slope: slope, hitting: BounceDirection.diagonal)
            print("DIAGNOAL - \(nextPoint) from \(point) along \(slope) - updating to \(newSlope)")
            return (point, newSlope)
        }

        while isObstacle(beside: nextPoint) == .none {
            guard nextPoint.y <= paddle.y else { return nil } // don't move past the paddle, no bounces on this path

            point = nextPoint
            nextPoint = point.next(on: slope)
        }

        let direction = isObstacle(beside: nextPoint)
        return (nextPoint, update(slope: slope, hitting: direction))
    }

    /// Update the slope given the direction it hits an obstacle.
    func update(slope: Coordinate.SlopeType, hitting direction: BounceDirection) -> Coordinate.SlopeType {
        switch slope {
        case .horizontal(direction: let slopeDirection):
            // ignoring direction... I mean we can't really do this in the arcade with the ball anyway
            return Coordinate.SlopeType.horizontal(direction: slopeDirection * -1)
        case .vertical(direction: let slopeDirection):
            // ignoring direction... I mean we can't really do this in the arcade with the ball anyway
            return Coordinate.SlopeType.vertical(direction: slopeDirection * -1)
        case .normal(slope: let slopeValue, direction: let slopeDirection):
            switch direction {
            case .down, .up:
                // if we hit anything going up/down, change direction AND slope
                return Coordinate.SlopeType.normal(slope: slopeValue * -1, direction: slopeDirection * -1)
            case .left, .right:
                // if we hit anything going left/right, change just the slope
                return Coordinate.SlopeType.normal(slope: slopeValue * -1, direction: slopeDirection)
            case .diagonal:
                // if we hit something along a diagnoal, just change the direction
                return Coordinate.SlopeType.normal(slope: slopeValue, direction: slopeDirection * -1)
            case .none:
                print("Why do we have none here?")
                return slope // ¯\_(ツ)_/¯
            }
        }
    }

    // check for obstacles beside the given point. (up,down,left,right)
    func isObstacle(beside location: Coordinate) -> BounceDirection {
        let directions: [BounceDirection] = [.up, .down, .left, .right]
        for direction in directions {
            var directionLocation: Coordinate
            switch direction {
            case .up:
                directionLocation = Coordinate(x: location.x, y: location.y - 1)
                if screen.solid(at: directionLocation) {
                    print("Bounce: Hit UP at \(directionLocation) - testing \(location)")
                    return direction
                }
            case .down:
                directionLocation = Coordinate(x: location.x, y: location.y + 1)
                if screen.solid(at: directionLocation) {
                    print("Bounce: Hit DOWN at \(directionLocation) - testing \(location)")
                    return direction
                }
            case .right:
                directionLocation = Coordinate(x: location.x + 1, y: location.y)
                if screen.solid(at: directionLocation) {
                    print("Bounce: Hit RIGHT at \(directionLocation) - testing \(location)")
                    return direction
                }
            case .left:
                directionLocation = Coordinate(x: location.x - 1, y: location.y)
                if screen.solid(at: directionLocation) {
                    print("Bounce: Hit LEFT at \(directionLocation) - testing \(location)")
                    return direction
                }
            case .diagonal:
                // we have to check all 4 diagonals... sigh
                for changes in [[1,1], [1,-1], [-1,1], [-1,-1]] {
                    directionLocation = Coordinate(x: location.x + changes[0], y: location.y + changes[1])
                    print("Diagonal from \(location) is \(directionLocation)")
                    if screen.solid(at: directionLocation) {
                        print("Bounce: Hit DIAGONAL at \(directionLocation) - testing \(location)")
                        return direction
                    }
                }
            case .none:
                continue
            }
        }

        return .none
    }

    private func processMachineOutputs() {
        let chunks = machine.outputs.chunks(size: 3)

        for chunk in chunks {
            guard chunk.count == 3 else { continue }
            if chunk[0] == -1 { // score is set in form of -1,0,<score>
                score = chunk[2]
            } else {
                screen.draw(input: chunk)
            }
        }

        machine.outputs.removeAll() // clear output
    }
}
