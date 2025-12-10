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

    init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }

    init?(_ input: String) {
        let numbers = input.split(separator: ",").map(String.init).compactMap(Int.init)
        guard numbers.count == 3 else { return nil }

        x = numbers[0]
        y = numbers[1]
        z = numbers[2]
    }

    func distance(to coordinate: ThreeDCoordinate) -> Float {
        sqrt(
            pow(Float(x - coordinate.x), 2.0) +
            pow(Float(y - coordinate.y), 2.0) +
            pow(Float(z - coordinate.z), 2.0)
        )
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

//import Playgrounds
//#Playground {
//    let first = ThreeDCoordinate("1,2,3")!
//    let second = ThreeDCoordinate("4,6,8")!
//
//    let distance = first.distance(to: second)
//}
