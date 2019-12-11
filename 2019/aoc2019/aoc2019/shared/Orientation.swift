//
//  Orientation.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/11/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

enum Orientation: Int {
    case north = 0
    case east = 1
    case south = 2
    case west = 3

    var printed: String {
        switch self {
        case .north:
            return "^"
        case .east:
            return ">"
        case .west:
            return "<"
        case .south:
            return "v"
        }
    }

    func turnRight() -> Orientation {
        if let newDirection = Orientation(rawValue: rawValue + 1) {
            return newDirection
        } else { // we must be facing west
            return .north
        }
    }

    func turnLeft() -> Orientation {
        if let newDirection = Orientation(rawValue: rawValue - 1) {
            return newDirection
        } else { // we must be facing north
            return .west
        }
    }
}
