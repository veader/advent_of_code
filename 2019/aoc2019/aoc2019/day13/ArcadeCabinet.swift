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

        var waitCount = 1_000_000

        while !finished {
            if case .finished(output: _) = machine.state {
                processMachineOutputs()

                print("Score: \(score)")
                // screen.printScreen()

                finished = true
            } else if case .awaitingInput = machine.state {
                processMachineOutputs()

                // print("Score: \(score)")
                // screen.printScreen()

                let move = calculateMove()
                // print("Joystick input: \(move)")
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
        guard
            let prevLocation = previousBallLocation,
            let currentLocation = screen.ballLocation,
            let paddleLocation = screen.paddleLocation
            else {
                previousBallLocation = screen.ballLocation
                return .neutral
            }

        var output: JoystickOrientation = .neutral

//        print("=========================================")
//        print("Paddle @ \(paddleLocation)")

        // find the slope of travel for the ball
        // REMEMBER: down is up and up is down, because of top-left origin
        let slope = prevLocation.slope(to: currentLocation)

        var pongBall = PongBall(position: currentLocation, slope: slope)
        if let intersection = pongBall.find(paddle: paddleLocation, screen: screen) {
//            print("Hit paddle @ \(intersection)")
//            print("Removed: \(pongBall.removedBlocks)")
//            print("")
//            screen.printPath(of: pongBall)

            // optimization: favor the middle, if we have time
            let ballHeight = intersection.y - currentLocation.y
            let ballDelta = abs(paddleLocation.x - intersection.x)
//            print("Ball height: \(ballHeight), delta: \(ballDelta)")
            if ballHeight - 2 > ballDelta {
                // attempt to favor towards middle, just in case
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

        // store the last place we saw the ball for next loop
        previousBallLocation = currentLocation

        return output
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
