//
//  CuboidGrid.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/28/21.
//

import Foundation

class CuboidGrid {
    let instructions: [CuboidInstruction]
    var cubesOn = Set<ThreeDCoordinate>()
    let xRange: ClosedRange<Int>
    let yRange: ClosedRange<Int>
    let zRange: ClosedRange<Int>

    init(instructions: [CuboidInstruction], xRange: ClosedRange<Int> = -50...50, yRange: ClosedRange<Int> = -50...50, zRange: ClosedRange<Int> = -50...50) {
        self.instructions = instructions
        self.xRange = xRange
        self.yRange = yRange
        self.zRange = zRange
    }

    func run() {
        print("Grid running \(instructions.count) instructions...")
        instructions.enumerated().forEach { idx, inst in
            switch inst.state {
            case .on:
                // add coordinates to our cubesOn set
                // let coordinates = valid(coordinates: inst.coordinates)
                let coordinates = coordinates(for: inst)
                cubesOn.formUnion(coordinates)
                print("\(idx) After turning ON \(coordinates.count) we now have \(cubesOn.count) on.")
            case .off:
                // remove coordinates (if there) from our cubesOn set
                // let coordinates = valid(coordinates: inst.coordinates)
                let coordinates = coordinates(for: inst)
                cubesOn.subtract(coordinates)
                print("\(idx) After turning OFF \(coordinates.count) we now have \(cubesOn.count) on.")
            }
        }
    }

    /// Return only the valid coordinates for this cuboid instruction
    func coordinates(for instruction: CuboidInstruction) -> [ThreeDCoordinate] {
        guard
            instruction.xRange.overlaps(xRange),
            instruction.yRange.overlaps(yRange),
            instruction.zRange.overlaps(zRange)
        else { return [] }

        return instruction.xRange.clamped(to: xRange).flatMap { x -> [ThreeDCoordinate] in
//            guard xRange.contains(x) else { return [] }
            return instruction.yRange.clamped(to: yRange).flatMap { y -> [ThreeDCoordinate] in
//                guard yRange.contains(y) else { return [] }
                return instruction.zRange.clamped(to: zRange).compactMap { z -> ThreeDCoordinate? in
//                    guard zRange.contains(z) else { return nil }
                    return ThreeDCoordinate(x: x, y: y, z: z)
                }
            }
        }
    }

    /// Remove any coordinate that isn't in our proper range
    func valid(coordinates: [ThreeDCoordinate]) -> [ThreeDCoordinate] {
        coordinates.filter { c in
            xRange.contains(c.x) && yRange.contains(c.y) && zRange.contains(c.z)
        }
    }
}
