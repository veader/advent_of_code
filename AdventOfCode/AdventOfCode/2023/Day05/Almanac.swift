//
//  Almanac.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/5/23.
//

import Foundation
import RegexBuilder

struct Almanac {
    enum Source: String {
        case seed
        case soil
        case fertilizer
        case water
        case light
        case temperature
        case humidity
        case location
    }

    struct MapRange {
        let source: Int
        let destination: Int
        let size: Int

        let sourceRange: ClosedRange<Int>

        var delta: Int {
            destination - source 
        }

        init(source: Int, destination: Int, size: Int) {
            self.source = source
            self.destination = destination
            self.size = size

            self.sourceRange = source...(source + (size-1))
        }

        /// If the given value can be mapped by this range, calculate it. Otherwise, return the number.
        func map(_ x: Int) -> Int {
            guard let idx = sourceRange.firstIndex(of: x) else { return x }
            return destination + sourceRange.distance(from: sourceRange.startIndex, to: idx)
        }

        /// Does this mapping contain this source value?
        func contains(_ x: Int) -> Bool {
            sourceRange.contains(x)
        }

        /// Parse the given input to attempt to create a `MapRange`
        ///
        /// Example: 45 77 23
        ///
        /// Source = 77, Destination = 45, Size = 23
        static func parse(_ input: String) -> MapRange? {
            let nums = input.split(separator: " ").map(String.init).compactMap(Int.init)
            guard nums.count == 3 else { return nil }
            return MapRange(source: nums[1], destination: nums[0], size: nums[2])
        }
    }

    struct Mapping {
        let source: Source
        let destination: Source
        let ranges: [MapRange]

        var sortedRanges: [MapRange] {
            ranges.sorted(by: { $0.sourceRange.lowerBound < $1.sourceRange.lowerBound })
        }

        /// Find the mapped value for the input.
        func map(_ x: Int) -> Int {
            guard let mapping = ranges.first(where: { $0.contains(x) }) else { return x }
            return mapping.map(x)
        }
    }


    // MARK: -

    let seeds: [Int]
    let mappings: [Mapping]

    /// Find the map which starts at the given source.
    func map(for source: Source) -> Mapping? {
        mappings.first(where: { $0.source == source })
    }

    /// Follow a seed to it's final location.
    func location(of seed: Int) -> Int? {
        var location = seed
        var source: Source = .seed

//        var route: String = ""

        while source != .location {
//            route += "\(source): \(location) ->"
            guard let map = map(for: source) else {
                print("Unable to find mapping for \(source)")
                return nil
            }

            location = map.map(location)
            source = map.destination
        }

//        route += "\(source): \(location)"
//        print(route)

        return location
    }

    func mergeMaps() {
        typealias DeltaMap = (range: ClosedRange<Int>, delta: Int)

        var deltaMaps: [DeltaMap] = []

        var currentLayer: Source = .seed

        while currentLayer != .location {
            guard let layerMap = map(for: currentLayer) else {
                print("💥 Error finding map for \(currentLayer)")
                return
            }

            if let ranges = map(for: currentLayer)?.sortedRanges {
                print("\(currentLayer.rawValue.capitalized) ranges (\(ranges.count):")
                for m in ranges {
                    // first see if this range is entirely contained in an existing range... this should only be 1
//                    if let containingMap = deltaMaps.first(where: { $0.range.contains(m.sourceRange) }) {
//                        print("\(m.sourceRange) contained within \(containingMap.range)")
//                    } else {
                        // next find all places where this range overlaps (partially) any existing range
                        let overlapMaps = deltaMaps.filter({ $0.range.overlaps(m.sourceRange) })
                        print("\(m.sourceRange) overlaps \(overlapMaps.map(\.range))")

                        if overlapMaps.count > 0 {
                            // divide things up
                        } else {
                            // add this new range?
                            deltaMaps.append((m.sourceRange, m.delta))
                        }
//                    }
                }
            }

            deltaMaps = deltaMaps.sorted(by: { $0.range.lowerBound < $1.range.lowerBound })
            print("* DeltaMaps after applying \(currentLayer): \(deltaMaps)")
            print("---------------------------------------")
            currentLayer = layerMap.destination // move down the stack
        }

        return
    }

    func seedRanges() -> [ClosedRange<Int>] {
        var ranges: [ClosedRange<Int>] = []
        var seedRanges = seeds
        while !seedRanges.isEmpty {
            guard seedRanges.count >= 2 else { seedRanges = []; continue }

            let range = seedRanges[0]...(seedRanges[0] + (seedRanges[1]-1))
            ranges.append(range)

            seedRanges.removeFirst(2)
        }

        return ranges
    }

    // MARK: -

    /// Parse the given input to create an Almanac
    static func parse(_ input: String) -> Almanac {
        let mapRegex = /(.*?)-to-(.*?) map:/

        var lines = input.split(separator: "\n").map(String.init)
        let seeds = lines.removeFirst().split(separator: " ").map(String.init).compactMap(Int.init)

        var maps: [Mapping] = []

        var currentMap: (source: Source, destination: Source)?
        var mapRanges: [MapRange] = []

        for line in lines {
            //print("Looking at \(line)")
            if let match = line.firstMatch(of: mapRegex) {
                // start of a new map, save off any previous one...
                if let currentMap {
                    let map = Mapping(source: currentMap.source, destination: currentMap.destination, ranges: mapRanges)
                    maps.append(map)
                }

                currentMap = nil
                mapRanges = []

                if let source = Source(rawValue: String(match.output.1)), let destination = Source(rawValue: String(match.output.2)) {
                    currentMap = (source, destination)
                } else {
                    print("💥 Error parsing map: \"\(line)\"")
                }
            } else if let range = MapRange.parse(line) {
                mapRanges.append(range)
            } else {
                print("💥 Error parsing line: \"\(line)\"")
            }
        }

        if let currentMap {
            let map = Mapping(source: currentMap.source, destination: currentMap.destination, ranges: mapRanges)
            maps.append(map)
        }

        return Almanac(seeds: seeds, mappings: maps)
    }
}
