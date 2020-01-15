//
//  Moon.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/12/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

class Moon {
    var position: ThreeDimPosition
    var velocity: ThreeDimPosition

    var potentialEnergy: Int {
        abs(position.x) + abs(position.y) + abs(position.z)
    }

    var kineticEnergy: Int {
        abs(velocity.x) + abs(velocity.y) + abs(velocity.z)
    }

    var totalEnergy: Int {
        kineticEnergy * potentialEnergy
    }

    var shortDescription: String {
        return "\(position.x),\(position.y),\(position.z):\(velocity.x),\(velocity.y),\(velocity.z)"
    }

    
    init(position: ThreeDimPosition) {
        self.position = position
        velocity = ThreeDimPosition(x: 0, y: 0, z: 0)
    }

    /// Calculate the change in velocity of both moons based on their position
    func applyGravity(toward moon: Moon) {
        // capture the changes needed before modifying either
        let ourChange = change(from: moon.position, to: position)
        let theirChange = change(from: position, to: moon.position)

        change(velocity: ourChange)
        moon.change(velocity: theirChange)
    }

    /// Update position based on current velocity
    func applyVelocity() {
        position = position.applying(change: velocity)
    }

    /// Calculate the new velocity given the changes described in a ThreeDimPosition
    func change(velocity velocityChange: ThreeDimPosition) {
        velocity = velocity.applying(change: velocityChange)
    }

    /// Calculate the change from one dimension to another.
    /// - returns: ThreeDimPosition describing the change.
    private func change(from first: ThreeDimPosition, to second: ThreeDimPosition) -> ThreeDimPosition {
        let xChange = change(from: first.x, to: second.x)
        let yChange = change(from: first.y, to: second.y)
        let zChange = change(from: first.z, to: second.z)

        return ThreeDimPosition(x: xChange, y: yChange, z: zChange)
    }

    /// Return 1, -1, 0 depending on the delta between first and second.
    private func change(from first: Int, to second: Int) -> Int {
        if first == second {
            return 0
        } else if first > second {
            return 1
        } else {
            return -1
        }
    }
}

extension Moon {
    convenience init?(input: String) {
        guard let pos = ThreeDimPosition(input: input) else { return nil }
        self.init(position: pos)
    }
}

extension Moon: Equatable, Hashable {
    static func == (lhs: Moon, rhs: Moon) -> Bool {
        lhs.position == rhs.position && lhs.velocity == rhs.velocity
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
        hasher.combine(velocity)
    }
}

extension Moon: CustomStringConvertible {
    var description: String {
        return "Moon(pos: \(position), velocity: \(velocity))"
    }
}
