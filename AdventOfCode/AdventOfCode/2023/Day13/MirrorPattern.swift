//
//  MirrorPattern.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/14/23.
//

import Foundation

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

    func reflection(fix: Bool = false) -> ReflectionPoint? {
        if let y = checkHorizontal(fix: fix) {
            return .horizontal(y: y + 1)
        } else if let x = checkVertical(fix: fix) {
            return .vertical(x: x + 1)
        }

        return nil
    }

    func checkHorizontal(fix: Bool = false) -> Int? {
        var y = 0
        while data.yBounds.contains(y + 1) {
            if reflectsHorizontally(from: y, fix: fix) {
                return y
            }
            y += 1
        }

        return nil
    }

    private func reflectsHorizontally(from y: Int, fix: Bool = false) -> Bool {
        var topY = y
        var bottomY = y + 1
        var smudgeFixed = false

        while data.yBounds.contains(topY) && data.yBounds.contains(bottomY) {
            // guard data.row(y: topY) == data.row(y: bottomY) else { return false }
            guard let topRow = data.row(y: topY), let bottomRow = data.row(y: bottomY) else { return false }
            if topRow != bottomRow {
                // if we are fixing and haven't fixed a smudge already, try it on this set
                if fix && !smudgeFixed && topRow.offByOne(from: bottomRow) {
                    smudgeFixed = true // fixed one, now continue
                } else {
                    return false // either they are more than one off or we've already fixed one
                }
            }
            topY -= 1
            bottomY += 1
        }

        if fix {
            // if we are fixing we must have fixed at least one
            return smudgeFixed
        } else {
            return true
        }
    }

    func checkVertical(fix: Bool = false) -> Int? {
        var x = 0
        while data.xBounds.contains(x + 1) {
            if reflectsVertically(from: x, fix: fix) {
                return x
            }
            x += 1
        }
        
        return nil
    }

    private func reflectsVertically(from x: Int, fix: Bool = false) -> Bool {
        var leftX = x
        var rightX = x + 1
        var smudgeFixed = false

        while data.xBounds.contains(leftX) && data.xBounds.contains(rightX) {
            // guard data.column(x: leftX) == data.column(x: rightX) else { return false }
            guard let leftRow = data.column(x: leftX), let rightRow = data.column(x: rightX) else { return false }
            if leftRow != rightRow {
                if fix && !smudgeFixed && leftRow.offByOne(from: rightRow) {
                    smudgeFixed = true
                } else {
                    return false
                }
            }
            leftX -= 1
            rightX += 1
        }

        if fix {
            // if we are fixing we must have fixed at least one
            return smudgeFixed
        } else {
            return true
        }
    }
}
