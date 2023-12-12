//
//  Day10_2023.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/10/23.
//

import Foundation

struct Day10_2023: AdventDay {
    var year = 2023
    var dayNumber = 10
    var dayTitle = "Pipe Maze"
    var stars = 1

    enum Day10Error: Error {
        case missingPipe
        case missingRoute
        case noStart
    }


    // MARK: -

    enum Pipe: String, CustomDebugStringConvertible {
        case vert = "|"     // connect north and south
        case horz = "-"     // connect east and west
        case ne90 = "L"     // connect north and east
        case nw90 = "J"     // connect north and west
        case sw90 = "7"     // connect south and west
        case se90 = "F"     // connect south and east
        case ground = "."   // no connections
        case start = "S"    // connect on any side NESW

        var debugDescription: String { rawValue }

        var attachments: [Coordinate.RelativeDirection] {
            switch self {
            case .vert:
                [.north, .south]
            case .horz:
                [.east, .west]
            case .ne90:
                [.north, .east]
            case .nw90:
                [.north, .west]
            case .sw90:
                [.south, .west]
            case .se90:
                [.south, .east]
            case .ground:
                []
            case .start:
                [.north, .east, .south, .west]
            }
        }
    }

    func pipeLength(grid: GridMap<Pipe>) throws -> [Coordinate] {
        guard let start = grid.first(where: { $0 == Pipe.start }) else { throw Day10Error.noStart }
        var current = start
        var direction = Coordinate.RelativeDirection.same
        var path: [Coordinate] = [start]
        var atStart = true

        while current != start || atStart {
            // find possible paths from this location considering direction being traveled currently
            let possible = try possiblePaths(from: current, traveling: direction, in: grid)

            // select the first one that contains a valid pipe and isn't going backwards
            let firstMatch = possible.first(where: { $0.pipe != nil && $0.direction.opposite != direction })
            guard let firstMatch else { throw Day10Error.missingRoute }

            current = firstMatch.coordinate
            direction = firstMatch.direction
            path.append(current)
            atStart = false
        }
        
        if let last = path.last, last == start {
            _ = path.popLast()
        }

        return path
    }

    typealias PipeConnection = (coordinate: Coordinate, direction: Coordinate.RelativeDirection, pipe: Pipe?)
    func possiblePaths(from coordinate: Coordinate, traveling direction: Coordinate.RelativeDirection, in grid: GridMap<Pipe>) throws -> [PipeConnection] {
        guard let pipe = grid.item(at: coordinate) else { throw Day10Error.missingPipe }
        
        // find the paths available from the coordinate. found by considering available directions
        //      based on the given pipe.
        return pipe.attachments.compactMap { dir -> PipeConnection? in
            // for each potential pipe, we need to know if it has an attachment point that aligns with us
            let c = coordinate.moving(direction: dir, originTopLeft: true)
            guard let p = grid.item(at: c) else { return nil }
            guard p.attachments.contains(where: { $0.opposite == dir }) else { return nil }
            return (c, dir, p)
        }
    }

    func area(within path: [Coordinate]) -> Int {
        var lookup: [Int: [Coordinate]] = [:]
        for c in path {
            lookup[c.y] = ((lookup[c.y] ?? []) + [c]).sorted(by: { $0.x < $1.x })
        }

        for y in lookup.keys.sorted() {
            print("\(y): \(lookup[y]!)")
        }

        for y in lookup.keys {
            let values = lookup[y] ?? []

            // remove any consecutive coordinates
            var toRemove = Set<Coordinate>()
            var lastC: Coordinate?
            for c in values {
                if let last = lastC, last.distance(to: c) == 1 {
                    // beside the last one, toss both
                    toRemove.insert(last)
                    toRemove.insert(c)
                }

                lastC = c
            }
            lookup[y] = Array(Set(values).subtracting(toRemove)).sorted(by: { $0.x < $1.x })
        }

        print("After removals...")
        for y in lookup.keys.sorted() {
            print("\(y): \(lookup[y]!)")
        }

        return 0
    }

    func areaByPainting(in grid: GridMap<Pipe>, path: [Coordinate], printGrid: Bool = false) -> Int {
        let blankGridFiller: [[String]] = grid.yBounds.map { _ in
            Array(repeating: " ", count: grid.xBounds.count)
        }

        let paintGrid = GridMap(items: blankGridFiller)

        // first, paint the path within the grid
        for c in path {
            paintGrid.update(at: c, with: "#")
        }
        
        if printGrid {
            paintGrid.printGrid()
        }

        // TODO: Alternative approach - Is there a way to count number of pipes encountered till you hit "outside"?
        outsideByPainting(grid: paintGrid)

        if printGrid {
            print(" ")
            paintGrid.printGrid()
        }

        return paintGrid.count(where: { $0 == " " })
    }

    func outsideByPainting(grid: GridMap<String>) {
        var grid = grid

        // next, start along the sides and paint anything that's "outside"
        var outside = Set<Coordinate>()
        for y in grid.yBounds {
            var edges = [Coordinate]()

            // special case for the top and bottom
            if y == grid.yBounds.lowerBound || y == (grid.yBounds.upperBound - 1) {
                for x in grid.xBounds {
                    edges.append(Coordinate(x: x, y: y))
                }
            }

            // left and right sides
            edges.append(Coordinate(x: grid.xBounds.lowerBound, y: y))
            edges.append(Coordinate(x: grid.xBounds.upperBound-1, y: y))

            for c in edges {
                if grid.item(at: c) != "#" {
                    grid.update(at: c, with: "O")
                    outside.insert(c)
                }
            }
        }


        while !outside.isEmpty {
            guard let c = outside.popFirst() else { print("🤯"); continue }
            let adjacent = grid.adjacentCoordinates(to: c, allowDiagonals: true)
            for aCoord in adjacent {
                if grid.item(at: aCoord) == " " {
                    grid.update(at: aCoord, with: "O")
                    outside.insert(aCoord)
                }
            }
        }
    }

    func parse(_ input: String?) -> GridMap<Pipe> {
        let pipes = (input ?? "").lines().map { line in
            line.charSplit().compactMap { Pipe(rawValue: $0) }
        }
        return GridMap<Pipe>(items: pipes)
    }


    // MARK: -

    func partOne(input: String?) -> Any {
        let grid = parse(input)

        do {
            let path = try pipeLength(grid: grid)
            let length = path.count
            return length / 2
        } catch {
            print("💥 Error: \(error.localizedDescription)")
            return -1
        }
    }

    func partTwo(input: String?) -> Any {
        let grid = parse(input)

        do {
            let path = try pipeLength(grid: grid)
            let area = areaByPainting(in: grid, path: path, printGrid: true)
            return area
        } catch {
            print("💥 Error: \(error.localizedDescription)")
            return -1
        }
    }
}
