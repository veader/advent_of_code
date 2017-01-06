#!/usr/bin/env swift

import Foundation

// ----------------------------------------------------------------------------
struct Map {
    let width: Int
    let height: Int
    let favorite: Int

    var coordinates: [[Coordinate]]
    var solution: [Coordinate]

    init(w theWidth: Int, h theHeight: Int, favorite fav: Int) {
        width = theWidth
        height = theHeight
        favorite = fav

        coordinates = [[Coordinate]]()
        solution = [Coordinate]()

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

    func open(from: Coordinate) -> [Coordinate] {
        var available = [Coordinate]()

        // cheating a bit and trying to go down and right first
        if from.y + 1 < height {
            let downSpot = spot(at: (from.x, from.y + 1))
            if !downSpot.isWall() {
                available.append(downSpot)
            }
        }
        if from.x + 1 < width {
            let rightSpot = spot(at: (from.x + 1, from.y))
            if !rightSpot.isWall() {
                available.append(rightSpot)
            }
        }
        if from.x - 1 >= 0 {
            let leftSpot = spot(at: (from.x - 1, from.y))
            if !leftSpot.isWall() {
                available.append(leftSpot)
            }
        }
        if from.y - 1 >= 0 {
            let upSpot = spot(at: (from.x, from.y - 1))
            if !upSpot.isWall() {
                available.append(upSpot)
            }
        }

        return available
    }

    func pathAsText(_ path: [Coordinate]) -> String {
        guard path.count > 0 else { return "NONE" }
        return path.map { "\($0.x),\($0.y)" }.joined(separator: " -> ")
    }

    mutating func navigate(to destination: (x: Int, y: Int), path current: [Coordinate] = [Coordinate]()) {
        if solution.count > 0 && current.count > solution.count {
            return
        }

        let currentCoordinate: Coordinate
        if let theCurrentCoordinate = current.last {
            currentCoordinate = theCurrentCoordinate
        } else {
            let startingCoordinate = spot(at: (1, 1)) // starting location
            navigate(to: destination, path: [startingCoordinate])
            return
        }

        // have we made it to the destination?
        if currentCoordinate.x == destination.x && currentCoordinate.y == destination.y {
            // print(pathAsText(current))
            // print("Current: \(current.count) Existing: \(solution.count)")
            if solution.count == 0 || current.count < solution.count {
                // print("First OR Shorter Solution")
                solution = current
            // } else {
            //     print("Alternate Solution")
            }
            return
        }

        let openCoordinates = open(from: currentCoordinate)

        // print(representation(path: current, goal: destination))

        if openCoordinates.count > 0 {
            for coord in openCoordinates {
                if !current.contains(coord) {
                    var newPath: [Coordinate] = current
                    newPath.append(coord)
                    navigate(to: destination, path: newPath)
                }
            }
        }
    }

    func representation(path: [Coordinate], goal: (x:Int, y:Int)? = nil) -> String {
        var gridDisplay = ""

        let xIndex = (0..<width).map { String($0 % 10) }.joined()
        gridDisplay.append("  \(xIndex)\n")

        (0..<height).forEach { y in
            let rowChars = row(y).map { c in
                if goal != nil && goal!.x == c.x && goal!.y == c.y {
                    return "G"
                } else if path.contains(c) {
                    return "O"
                } else {
                    return c.debugDescription
                }
            }.joined()
            gridDisplay.append("\(String(y % 10)) \(rowChars)")
            gridDisplay.append("\n")
        }

        return gridDisplay
    }
}

extension Map: CustomDebugStringConvertible {
    var debugDescription: String {
        return representation(path: solution)
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

extension Coordinate: Equatable {}
func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

extension Coordinate: CustomDebugStringConvertible {
    var debugDescription: String {
        return isWall() ? "#" : "."
    }
}

// ----------------------------------------------------------------------------
let favorite = 1350 // 10
let width  = 41 // 10
let height = 42 // 10

var map = Map.init(w: width, h: height, favorite: favorite)
print(map)
map.navigate(to: (31, 39)) // 7,4
print(map)

print("Shortest path: \(map.solution.count - 1) steps") // remove 1 since 1,1 is in the list
