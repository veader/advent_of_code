//
//  ThreeDCoordinate.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/17/20.
//

import Foundation

struct ThreeDCoordinate: Equatable, Hashable {
    let x: Int
    let y: Int
    let z: Int

    var neighboringCoordinates: [ThreeDCoordinate] {
        (x-1...x+1).flatMap { nx -> [ThreeDCoordinate] in
            (y-1...y+1).flatMap { ny -> [ThreeDCoordinate] in
                (z-1...z+1).compactMap { nz -> ThreeDCoordinate? in
                    let neighbor = ThreeDCoordinate(x: nx, y: ny, z: nz)
                    guard neighbor != self else { return nil } // don't include ourselves
                    return neighbor
                }
            }
        }
    }
}

extension ThreeDCoordinate: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        "(x: \(x), y: \(y), z: \(z))"
    }

    var debugDescription: String {
        description
    }
}
