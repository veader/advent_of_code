//
//  ReflectorDish.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/14/23.
//

import Foundation

struct ReflectorDish {
    enum MirrorPoint: String, CustomDebugStringConvertible, Equatable {
        case empty = "."
        case roundRock = "O"
        case squareRock = "#"

        var debugDescription: String { rawValue }
    }

    let data: GridMap<MirrorPoint>

    init(_ input: String) {
        let gridData = input.lines().map { $0.charSplit().compactMap(MirrorPoint.init) }
        data = GridMap(items: gridData)
    }

    func calculateLoad() -> Int {
        var load = 0
        for (idx, row) in data.items.enumerated() {
            let count = row.filter({ $0 == .roundRock}).count
            load += count * (data.items.count - idx)
        }
        return load
    }

    func spinCycle(count: Int) {
        var completed = 0
        while completed < count {
            spin()
            completed += 1
            if (completed % 100_000) == 0 {
                print("\(Date.now) Spun \(completed)...")
            }
        }
    }

    func spin() {
        tilt(direction: .north)
        tilt(direction: .west)
        tilt(direction: .south)
        tilt(direction: .east)
    }

    func tilt(direction: Coordinate.RelativeDirection = .north) {
        switch direction {
        case .north:
            tiltVertical()
        case .south:
            tiltVertical(reverse: true)
        case .east:
            tiltHorizontal(reverse: true)
        case .west:
            tiltHorizontal()
        default:
            print("Nothing...")
        }
    }

    func tiltVertical(reverse: Bool = false) {
        for x in data.xBounds {
            guard var col = data.column(x: x) else { continue }
            if reverse {
                col.reverse()
            }

            var updatedCol = roll(col)
            if reverse {
                updatedCol.reverse()
            }

            for (y, pt) in updatedCol.enumerated() {
                data.update(at: Coordinate(x: x, y: y), with: pt)
            }
        }
    }

    func tiltHorizontal(reverse: Bool = false) {
        for y in data.yBounds {
            guard var row = data.row(y: y) else { continue }
            if reverse {
                row.reverse()
            }

            var updatedRow = roll(row)
            if reverse {
                updatedRow.reverse()
            }

            for (x, pt) in updatedRow.enumerated() {
                data.update(at: Coordinate(x: x, y: y), with: pt)
            }
        }
    }

    func roll(_ points: [MirrorPoint]) -> [MirrorPoint] {
        var copy = points
        var placementIndex: Int = copy.firstIndex(of: .empty) ?? 0
        var workingIndex: Int = placementIndex + 1

        while workingIndex < copy.count {
            //print("\(copy) pi:\(placementIndex) wi:\(workingIndex)")
            let pt = copy[workingIndex]
            switch pt {
            case .empty:
                workingIndex += 1 // move to the next index
                continue
            case .squareRock:
                // placement should move to the next empty spot
                if let nextEmpty = copy.suffix(from: workingIndex).firstIndex(of: .empty) {
                    placementIndex = nextEmpty
                    workingIndex = placementIndex
                } else {
                    // no more empty.. break out?
                    return copy
                }
                continue
            case .roundRock:
                // roll this rock back to the empty spot
                copy[workingIndex] = .empty
                copy[placementIndex] = .roundRock

                workingIndex += 1

                // placement should move to the next empty spot
                if let nextEmpty = copy.suffix(from: placementIndex).firstIndex(of: .empty) {
                    placementIndex = nextEmpty
                } else {
                    // no more empty.. break out?
                    return copy
                }
            }
        }

        return copy
    }
}
