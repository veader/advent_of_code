//
//  CuboidInstruction.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/28/21.
//

import Foundation

struct CuboidInstruction {
    enum CuboidInstructionState: String {
        case on
        case off
    }

    let state: CuboidInstructionState
    let xRange: ClosedRange<Int>
    let yRange: ClosedRange<Int>
    let zRange: ClosedRange<Int>

    var coordinates: [ThreeDCoordinate] {
        xRange.flatMap { x in
            yRange.flatMap { y in
                zRange.map { z in
                    ThreeDCoordinate(x: x, y: y, z: z)
                }
            }
        }
    }

    static func parse(_ input: String) -> CuboidInstruction? {
        // https://rubular.com/r/I1jRWTj4SmIVTI
        let regex = "(on|off)\\s+x=(-?\\d+)\\.\\.(-?\\d+),y=(-?\\d+)\\.\\.(-?\\d+),z=(-?\\d+)\\.\\.(-?\\d+)"
        guard
            let match = input.matching(regex: regex),
            let state = CuboidInstructionState(rawValue: match.captures[0]),
            let xStart = Int(match.captures[1]),
            let xEnd = Int(match.captures[2]),
            let yStart = Int(match.captures[3]),
            let yEnd = Int(match.captures[4]),
            let zStart = Int(match.captures[5]),
            let zEnd = Int(match.captures[6])
        else { return nil}

        return CuboidInstruction(state: state,
                                 xRange: xStart...xEnd,
                                 yRange: yStart...yEnd,
                                 zRange: zStart...zEnd)
    }
}
