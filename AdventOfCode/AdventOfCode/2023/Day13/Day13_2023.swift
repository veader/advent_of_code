//
//  Day13_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/13/23.
//

import Foundation

struct Day13_2023: AdventDay {
    var year = 2023
    var dayNumber = 13
    var dayTitle = "Point of Incidence"
    var stars = 1

    struct MirrorPattern {
        enum ReflectionPoint: Equatable {
            case horizontal(y: Int)
            case vertical(x: Int)
        }

        let data: GridMap<String>

        init(_ input: String) {
            let mapData = input.lines().map { $0.charSplit() }
            data = GridMap(items: mapData)
        }

        func reflection() -> ReflectionPoint? {
            if let y = checkHorizontal() {
                return .horizontal(y: y + 1)
            } else if let x = checkVertical() {
                return .vertical(x: x + 1)
            }

            return nil
        }

        private func checkHorizontal() -> Int? {
            var y = 0
            while data.yBounds.contains(y + 1) {
                if reflectsHorizontally(from: y) {
                    return y
                }
                y += 1
            }

            return nil
        }

        private func reflectsHorizontally(from y: Int) -> Bool {
            var topY = y
            var bottomY = y + 1

            while data.yBounds.contains(topY) && data.yBounds.contains(bottomY) {
                guard data.row(y: topY) == data.row(y: bottomY) else { return false }
                topY -= 1
                bottomY += 1
            }

            return true
        }

        private func checkVertical() -> Int? {
            var x = 0
            while data.xBounds.contains(x + 1) {
                if reflectsVertically(from: x) {
                    return x
                }
                x += 1
            }
            
            return nil
        }

        private func reflectsVertically(from x: Int) -> Bool {
            var leftX = x
            var rightX = x + 1

            while data.xBounds.contains(leftX) && data.xBounds.contains(rightX) {
                guard data.column(x: leftX) == data.column(x: rightX) else { return false }
                leftX -= 1
                rightX += 1
            }

            return true
        }
    }

    func parse(_ input: String?) -> [MirrorPattern] {
        (input ?? "").split(separator: "\n\n").map(String.init).map(MirrorPattern.init)
    }

    func partOne(input: String?) -> Any {
        let patterns = parse(input)
        let patternNotes = patterns.map { pattern in
            guard let reflection = pattern.reflection() else { print("No reflection!"); return 0 }
            
            switch reflection {
            case .vertical(x: let x):
                return x
            case .horizontal(y: let y):
                return y * 100
            }
        }

        return patternNotes.reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
