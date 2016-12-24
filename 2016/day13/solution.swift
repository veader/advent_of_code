#!/usr/bin/env swift

import Foundation

// ----------------------------------------------------------------------------
struct Map {
    let width: Int
    let height: Int
    let favorite: Int

    var coordinates: [[Coordinate]]

    init(w theWidth: Int, h theHeight: Int, favorite fav: Int) {
        width = theWidth
        height = theHeight
        favorite = fav

        coordinates = [[Coordinate]]()

        (0..<width).forEach { x in
            let column = (0..<height).map { y in
                Coordinate.init(x: x, y: y, favorite: favorite)
            }
            coordinates.append(column)
        }
    }

    func row(_ y: Int) -> [Coordinate] {
        return (0..<width).map { spot(at: ($0, y)) }
    }

    func column(_ x: Int) -> [Coordinate] {
        return (0..<height).map { spot(at: (x, $0)) }
    }

    func spot(at: (x: Int, y: Int)) -> Coordinate {
        return coordinates[at.x][at.y]
    }
}

extension Map: CustomDebugStringConvertible {
    var debugDescription: String {
        var gridDisplay = ""

        let xIndex = (0..<width).map { String($0 % 10) }.joined()
        gridDisplay.append("  \(xIndex)\n")

        (0..<height).forEach { y in
            let rowChars = row(y).map { $0.debugDescription }.joined()
            gridDisplay.append("\(String(y % 10)) \(rowChars)")
            gridDisplay.append("\n")
        }

        return gridDisplay
    }
}

// ----------------------------------------------------------------------------
struct Coordinate {
    let x: Int
    let y: Int
    let favorite: Int

    func binary() -> String {
        return String(equation(), radix: 2)
    }

    private func equation() -> Int {
        let num = x*x + 3*x + 2*x*y + y + y*y
        return num + favorite
    }

    func isWall() -> Bool {
        let oneCount = binary().characters.filter { $0 == "1" }.count
        return oneCount % 2 == 1
    }
}

extension Coordinate: CustomDebugStringConvertible {
    var debugDescription: String {
        let wall = isWall() ? "#" : "."
        // return "X: \(x) Y: \(y) - \(wall)"
        return wall
    }
}

// ----------------------------------------------------------------------------
let favorite = 1350

let map = Map.init(w: 40, h: 40, favorite: favorite)
print(map)
