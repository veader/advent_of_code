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
        return 0
    }
}
