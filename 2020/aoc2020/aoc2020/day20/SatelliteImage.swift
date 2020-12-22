//
//  SatelliteImage.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/22/20.
//

import Foundation

class SatelliteImage {
    /// Dictionary of satellite images based on their tile ID
    var tiles: [Int: SatelliteImageTile]

    var tileAlignments: [Int: [Int]]

    init(_ input: String) {
        let theTiles = input.replacingOccurrences(of: "\n\n", with: "|")
                            .split(separator: "|")
                            .map(String.init)
                            .compactMap { SatelliteImageTile($0) }

        tiles = [Int: SatelliteImageTile]()
        for tile in theTiles {
            tiles[tile.tileID] = tile
        }

        tileAlignments = [Int: [Int]]()
    }

    func mapTiles() {
        var tilesToConsider = Array(tiles.values)
        while !tilesToConsider.isEmpty {
            let tile = tilesToConsider.removeFirst()
            for otherTile in tilesToConsider {
                if tile.aligns(with: otherTile) {
                    // store this mapping for both tiles
                    recordAlignment(tile1: tile, tile2: otherTile)
                    recordAlignment(tile1: otherTile, tile2: tile)
                }
            }
        }
    }

    /// Find the tile IDs of the corners of the image
    func findCorners() -> [Int] {
        mapTiles()
        return tileAlignments.filter({ $0.value.count == 2 }).map { $0.key }
    }

    private func recordAlignment(tile1: SatelliteImageTile, tile2: SatelliteImageTile) {
        var alignments = tileAlignments[tile1.tileID] ?? []
        alignments.append(tile2.tileID)
        tileAlignments[tile1.tileID] = alignments
    }
}
