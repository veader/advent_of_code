//
//  GridMap.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/9/21.
//

import Foundation

struct GridMap<Element> {
    let items: [[Element]]
    let xBounds: Range<Int>
    let yBounds: Range<Int>

    init(items: [[Element]]) {
        self.items = items
        self.xBounds = 0..<(items.first ?? []).count
        self.yBounds = 0..<items.count
    }

    /// Return the item at the given coordinate.
    ///
    /// Nil if coordinate not found in grid.
    func item(at coordinate: Coordinate) -> Element? {
        guard
            items.indices.contains(coordinate.y),
            items[coordinate.y].indices.contains(coordinate.x)
        else { return nil }

        return items[coordinate.y][coordinate.x]
    }

    /// Return the item at the given x,y coordinate.
    ///
    /// Nil if x and y are not found in grid.
    func itemAt(x: Int, y: Int) -> Element? {
        item(at: Coordinate(x: x, y: y))
    }

    /// Return all coordinates adjacent to the given coordinate.
    func adjacentCoordinates(to coordinate: Coordinate) -> [Coordinate] {
        coordinate.adjacent(xBounds: ClosedRange(xBounds), yBounds: ClosedRange(yBounds))
    }

    /// Return all items adjacent to the given coordinate.
    func adjacentItems(to coordinate: Coordinate) -> [Element] {
        adjacentCoordinates(to: coordinate).compactMap { item(at: $0) }
    }

    /// All available coordinates in the grid space.
    func coordinates() -> [Coordinate] {
        yBounds.flatMap { y in
            xBounds.map { x in
                Coordinate(x: x, y: y)
            }
        }
    }

    /// Filter the grid by mapping to the coordinate, item pair.
    /// Returns the coordinate which return true when passed to the given block.
    func filter(by filterBlock: ((Coordinate, Element) -> Bool)) -> [Coordinate] {
        coordinates().filter { c in
            guard let item = item(at: c) else { return false }
            return filterBlock(c, item)
        }
    }

    func printSize() {
        print("Grid: \(xBounds.upperBound)x\(yBounds.upperBound)")
    }
}
