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
