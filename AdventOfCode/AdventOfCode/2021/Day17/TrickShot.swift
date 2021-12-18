//
//  TrickShot.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/17/21.
//

import Foundation

class TrickShot {
    let targetAreaX: ClosedRange<Int>
    let targetAreaY: ClosedRange<Int>

    var workingShots = [[Int]]()
    var highestHeight: Int = 0

    enum ShotMetrics {
        case fellShort
        case overShot
        case hit(maxHeight: Int)
    }

    init(areaX: ClosedRange<Int>, areaY: ClosedRange<Int>) {
        targetAreaX = areaX
        targetAreaY = areaY
    }

    func findShots() {
        for x in (0...targetAreaX.upperBound) {
//            print("Considering x: \(x)")
            for y in (targetAreaY.lowerBound..<1000) {
                let result = modelShot(horizontal: x, vertical: y)
                if case .hit(let maxHeight) = result {
//                    print("\tVertical \(y) hits with max height of \(maxHeight)")
                    highestHeight = max(highestHeight, maxHeight)
                    workingShots.append([x,y])
                } else if case .overShot = result {
//                    print("\tOvershot starting with \(y). Stopping...")
                    break
                }
            }
        }

        print("-------------")
        print(workingShots)
        print("\n Count: \(workingShots.count)")
        print("\n Highest: \(highestHeight)")
    }

    func modelShot(horizontal: Int, vertical: Int, debugPrint: Bool = false) -> ShotMetrics {
        var result: ShotMetrics?

        var point = Coordinate(x: 0, y: 0) // start at origin
        var horizontalComp = horizontal
        var verticalComp = vertical
        var maxHeight = 0

        if debugPrint { print("Modeling \(horizontal), \(vertical)...") }

        while inBounds(point) && result == nil {
            // move point
            point = point.moving(xOffset: horizontalComp, yOffset: verticalComp)
            maxHeight = max(maxHeight, point.y)

            if debugPrint { print("\t\(point) with maxHeight \(maxHeight)") }

            // adjust coeffiecient/components
            horizontalComp = max(0, horizontalComp - 1)
            verticalComp -= 1

            if inTargetArea(point) {
                if debugPrint { print("HIT!") }
                result = .hit(maxHeight: maxHeight)
            } else if point.x > targetAreaX.upperBound {
                result = .overShot
            } else if point.y < targetAreaY.lowerBound {
                result = .fellShort
            }
        }

        guard let result = result else { return .fellShort } // not sure what would cause this...
        return result
    }

    /// Determine if the given coordinate is "in bounds".
    ///
    /// Meaning is the X less than the `targetAreaX.upperBound` and Y greater then `targetAreaY.lowerBound`.
    func inBounds(_ coordinate: Coordinate) -> Bool {
        coordinate.x <= targetAreaX.upperBound &&
        coordinate.y >= targetAreaY.lowerBound
    }

    func inTargetArea(_ coordinate: Coordinate) -> Bool {
        targetAreaX.contains(coordinate.x) && targetAreaY.contains(coordinate.y)
    }
}
