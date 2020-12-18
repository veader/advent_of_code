//
//  FourDCoordinate.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/17/20.
//

import Foundation

struct FourDCoordinate: PowerSourceCoordinate, Equatable, Hashable {
    let x: Int
    let y: Int
    let z: Int
    let w: Int

    var neighboringCoordinates: [FourDCoordinate] {
        (x-1...x+1).flatMap { nx -> [FourDCoordinate] in
            (y-1...y+1).flatMap { ny -> [FourDCoordinate] in
                (z-1...z+1).flatMap { nz -> [FourDCoordinate] in
                    (w-1...w+1).compactMap { nw -> FourDCoordinate? in
                        let neighbor = FourDCoordinate(x: nx, y: ny, z: nz, w: nw)
                        guard neighbor != self else { return nil } // don't include ourselves
                        return neighbor
                    }
                }
            }
        }
    }
}

extension FourDCoordinate: CustomDebugStringConvertible {
    var debugDescription: String {
        "(x: \(x), y: \(y), z: \(z), w: \(w)"
    }
}
