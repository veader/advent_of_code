//
//  File.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/17/20.
//

import Foundation

struct TreeDCoordinate: Equatable, Hashable {
    let x: Int
    let y: Int
    let z: Int

    var neighboringCoordinates: [TreeDCoordinate] {
        (x-1...x+1).flatMap { nx -> [TreeDCoordinate] in
            (y-1...y+1).flatMap { ny -> [TreeDCoordinate] in
                (z-1...z+1).compactMap { nz -> TreeDCoordinate? in
                    let neighbor = TreeDCoordinate(x: nx, y: ny, z: nz)
                    guard neighbor != self else { return nil } // don't include ourselves
                    return neighbor
                }
            }
        }
    }
}

extension TreeDCoordinate: CustomDebugStringConvertible {
    var debugDescription: String {
        "(x: \(x), y: \(y), z: \(z))"
    }
}
