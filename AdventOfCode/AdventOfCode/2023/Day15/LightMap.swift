//
//  LightMap.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/18/23.
//

import Foundation

class LightMap {
    enum MapObjects: String, Equatable, CustomDebugStringConvertible {
        case space = "."
        case splitterVertical = "|"
        case splitterHorizontal = "-"
        case mirrorBackSlash = "\\"
        case mirrorForwardSlash = "/"

        var debugDescription: String { rawValue }
    }

    let data: GridMap<MapObjects>
    var energizedPoints: Set<Coordinate> // points that are energized by light passing through
    var lightPaths: Set<String> // place + direction of light paths to prevent duplicate work

    init(_ input: String) {
        let bits = input.lines().map { line in
            line.charSplit().compactMap { MapObjects(rawValue: $0) }
        }

        data = GridMap(items: bits)
        energizedPoints = []
        lightPaths = []
    }

    func traceLight() async {
        // reset!
        energizedPoints = []
        lightPaths = []

        // trace!
        await followLight(.origin, traveling: .east)
    }

    func followLight(_ location: Coordinate, traveling: Coordinate.RelativeDirection) async {
        guard [.north, .south, .east, .west].contains(traveling) else { return } // only using major cardinal directions

        var current = location
        var direction = traveling

        while data.valid(coordinate: current) {
            // avoid duplicate work if we've been at this point traveling in this same direction
            let path = "\(current.x)x\(current.y)-\(direction)"
            guard !lightPaths.contains(path) else { return }
            lightPaths.insert(path) // mark locaton + direction

            energizedPoints.insert(current) // we traveled through this point...

            switch data.item(at: current) {
            case .space:
                break // keep going
            case .mirrorBackSlash:
                if case .east = direction {
                    direction = .south
                } else if case .west = direction {
                    direction = .north
                } else if case .north = direction {
                    direction = .west
                } else if case .south = direction {
                    direction = .east
                }
            case .mirrorForwardSlash:
                if case .east = direction {
                    direction = .north
                } else if case .west = direction {
                    direction = .south
                } else if case .north = direction {
                    direction = .east
                } else if case .south = direction {
                    direction = .west
                }
            case .splitterVertical:
                if [.east, .west].contains(direction) {
                    // split into two
                    await followLight(current.moving(direction: .north, originTopLeft: true), traveling: .north)
                    await followLight(current.moving(direction: .south, originTopLeft: true), traveling: .south)
                    return
                } // else pass through
            case .splitterHorizontal:
                if [.north, .south].contains(direction) {
                    // split into two
                    await followLight(current.moving(direction: .east, originTopLeft: true), traveling: .east)
                    await followLight(current.moving(direction: .west, originTopLeft: true), traveling: .west)
                    return
                } // else pass through
            default:
                print("Huh? \(current)")
                return
            }

            current = current.moving(direction: direction, originTopLeft: true)
        }
    }
}
