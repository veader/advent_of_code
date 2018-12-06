//
//  Coordinate.swift
//  AdventOfCode2018
//
//  Created by Shawn Veader on 12/6/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import Foundation

public struct Coordinate: Hashable, Equatable {
    let x: Int
    let y: Int
    let name: String?

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.name = nil
    }

    init(coordinate: Coordinate, name: String) {
        self.x = coordinate.x
        self.y = coordinate.y
        self.name = name
    }

    /// Returns the Manhattan distance between two coordinates.
    func distance(to coordB: Coordinate) -> Int {
        return abs(x - coordB.x) + abs(y - coordB.y)
    }

    public static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        // don't check the name
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
