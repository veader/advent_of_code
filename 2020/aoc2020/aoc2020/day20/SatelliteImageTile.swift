//
//  SatelliteImageTile.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/20/20.
//

import Foundation

struct SatelliteImageTile {

    struct Edges {
        let top: [String]
        let right: [String]
        let bottom: [String]
        let left: [String]

        var topString: String {
            top.joined()
        }

        var rightString: String {
            right.joined()
        }

        var bottomString: String {
            bottom.joined()
        }

        var leftString: String {
            left.joined()
        }

        var asArray: [[String]] {
            [top, right, bottom, left]
        }
    }

    /// Tile ID
    let tileID: Int

    /// 2D image data
    let data: [[String]]

    init?(_ input: String) {
        var lines = input.split(separator: "\n").map(String.init)

        // pull out the tile ID
        let tileLine = lines.removeFirst()
        guard
            let match = tileLine.matching(regex: "Tile ([0-9]*):"),
            let stringID = match.captures.first,
            let theID = Int(stringID)
            else { return nil }

        tileID = theID
        data = lines.map { $0.map(String.init) }
    }

    func edges() -> Edges? {
        guard let topEdge = data.first, let bottomEdge = data.last else { return nil }
        let rightEdge = data.compactMap { $0.last }
        let leftEdge = Array(data.compactMap({ $0.first }).reversed())

        return Edges(top: topEdge, right: rightEdge, bottom: bottomEdge, left: leftEdge)
    }

    /// Determine if this image and the given image share at least one edge
    func aligns(with image: SatelliteImageTile) -> Bool {
        guard
            let ourEdges = edges(),
            let theirEdges = image.edges()?.asArray
            else { return false }

        let edge = ourEdges.asArray.first { (edge: [String]) -> Bool in
            theirEdges.contains(edge) || theirEdges.contains(Array(edge.reversed()))
        }

        return edge != nil
    }
}
