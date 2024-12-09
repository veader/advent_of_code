//
//  AntennaMap.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/8/24.
//

import Foundation

class AntennaMap {
    let map: GridMap<String>
    var frequencies: [String] = []
    var antennas: [String: [Coordinate]] = [:]

    init(map: GridMap<String>) {
        self.map = map
        let initialAntennas = map.filter { $1 != "." }
        initialAntennas.forEach { ant in
            if let item = map.item(at: ant) {
                self.antennas[item] = (antennas[item] ?? []) + [ant]
            }
        }
        self.frequencies = self.antennas.keys.map(\.self)
        // frequencies = map.filter { $1 != "." }.compactMap { map.item(at: $0) }.unique()
    }

    func findAntinodes(withHarmonics: Bool = false) -> [Coordinate] {
        antennas.keys.flatMap { findAntinodes(for: $0, withHarmonics: withHarmonics) }.unique()
    }

    func findAntinodes(for freq: String, withHarmonics: Bool = false) -> [Coordinate] {
        var nodes: [Coordinate] = []

        let ants = antennas[freq] ?? []
        for pair in ants.pairCombinations() {
            nodes.append(contentsOf: antinodes(for: pair[0], and: pair[1], withHarmonics: withHarmonics))
        }

        return nodes
    }

    func antinodes(for c1: Coordinate, and c2: Coordinate, withHarmonics: Bool = false) -> [Coordinate] {
        let points = [c1, c2].sorted()
        let delta = points[0].delta(to: points[1])
        let nodes = [
            applying(delta: delta, to: points[0], withHarmonics: withHarmonics),
            applying(delta: delta.opposite, to: points[1], withHarmonics: withHarmonics),
        ].flatMap({ $0 })
        return nodes  //.filter { map.valid(coordinate: $0) }
    }

    /// Apply the delta starting at the point given, only returning coordinates within the coordinate grid.
    ///
    /// - Note: When `withHarmonics` is `true` the logic will continue until the point is out of bounds.
    /// When `false` it will just be the first "fundamental"...
    private func applying(delta: Coordinate.GridDelta, to c1: Coordinate, withHarmonics: Bool) -> [Coordinate] {
        var points: [Coordinate] = []
        var point = c1.applying(delta: delta, originTopLeft: true)

        while map.valid(coordinate: point) {
            points.append(point)

            guard withHarmonics else { break }
            point = point.applying(delta: delta, originTopLeft: true)
        }

        if withHarmonics {
            points.append(c1) // harmonic at the point of the antenna too...
        }

        return points
    }

}

extension Coordinate {
    /// The delta between two points (x offset and y offset)
    struct GridDelta {
        let x: Int
        let y: Int

        /// What is the opposite delta of this delta.
        ///
        /// Example: (X, Y) -> (-X, -Y) or (X, -Y) -> (-X, Y)
        var opposite: GridDelta {
            GridDelta(x: -x, y: -y)
        }
    }

    /// The "delta" (meaning x offset and y offset) from this point to another.
    func delta(to c2: Coordinate, originTopLeft: Bool = false) -> GridDelta {
        if originTopLeft {
            GridDelta(x: c2.x - self.x, y: c2.y - self.y)
        } else {
            GridDelta(x: self.x - c2.x, y: self.y - c2.y)
        }
    }

    /// Apply the "delta" to the given coordinate to find the new coordinate.
    func applying(delta: GridDelta, originTopLeft: Bool = false) -> Coordinate {
        if originTopLeft {
            Coordinate(x: self.x + delta.x, y: self.y + delta.y)
        } else {
            Coordinate(x: self.x - delta.x, y: self.y - delta.y)
        }
    }
}

struct GridLine: Equatable {
    let start: Coordinate
    let end: Coordinate

    var points: [Coordinate] {
        [start, end]
    }

    init(start: Coordinate, end: Coordinate) {
        let coords = [start, end].sorted()
        self.start = coords[0]
        self.end = coords[1]
    }

    public static func == (lhs: GridLine, rhs: GridLine) -> Bool {
        // reversed shouldn't be needed now that we are sorting on init...
        return (lhs.points == rhs.points) // || (lhs.points == rhs.points.reversed())
    }
}
