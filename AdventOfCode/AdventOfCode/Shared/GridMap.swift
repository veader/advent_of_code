//
//  GridMap.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/9/21.
//

import Foundation

class GridMap<Element> {
    var items: [[Element]]
    let xBounds: Range<Int>
    let yBounds: Range<Int>

    init(items: [[Element]]) {
        self.items = items
        self.xBounds = 0..<(items.first ?? []).count
        self.yBounds = 0..<items.count
    }

    // MARK: -

    /// Return the item at the given coordinate.
    ///
    /// Nil if coordinate not found in grid.
    func item(at coordinate: Coordinate) -> Element? {
        guard isValid(coordinate: coordinate) else { return nil }
        return items[coordinate.y][coordinate.x]
    }

    /// Return the item at the given x,y coordinate.
    ///
    /// Nil if x and y are not found in grid.
    func itemAt(x: Int, y: Int) -> Element? {
        item(at: Coordinate(x: x, y: y))
    }

    /// Return a row at the given y offset.
    func row(y: Int) -> [Element]? {
        guard items.indices.contains(y) else { return nil }
        return items[y]
    }

    /// Update the value at the given coordinate with the new value.
    ///
    /// - returns: Success/failure of the update
    @discardableResult
    func update(at coordinate: Coordinate, with newValue: Element) -> Bool {
        guard isValid(coordinate: coordinate) else { return false }
        items[coordinate.y][coordinate.x] = newValue
        return true
    }

    /// Update the value at the given coordinate by calling the given block.
    ///
    /// - returns: Success/failure of the update
    @discardableResult
    func update(at coordinate: Coordinate, by updateBlock: (Element) -> Element) -> Bool {
        guard isValid(coordinate: coordinate) else { return false }
        let currentValue = items[coordinate.y][coordinate.x]
        items[coordinate.y][coordinate.x] = updateBlock(currentValue)
        return true
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

    /// Iterate through each element of the grid and update the value based on the response of the given block.
    func updateEach(_ updateBlock: ((Coordinate, Element) -> Element)) {
        coordinates().forEach { c in
            guard let currentValue = item(at: c) else { return }
            let newValue = updateBlock(c, currentValue)
            update(at: c, with: newValue)
        }
    }

    /// Print the size (width x height) of the grid.
    func printSize() {
        print("Grid: \(xBounds.upperBound)x\(yBounds.upperBound)")
    }

    /// Simple print of current grid.
    ///
    /// - note: Careful on very large grid sizes...
    func printGrid() {
        var output = [String]()
        yBounds.forEach { y in
            var row = [String]()
            xBounds.forEach { x in
                if let value = itemAt(x: x, y: y) {
                    row.append("\(value)")
                } else {
                    row.append("#")
                }
            }
            output.append(row.joined())
        }
        print(output.joined(separator: "\n") + "\n")
    }

    
    // Mark: - Private Methods

    /// Is the given coordinate valid? (ie: within the coordinate space of the grid)
    private func isValid(coordinate: Coordinate) -> Bool {
        guard
            items.indices.contains(coordinate.y),
            items[coordinate.y].indices.contains(coordinate.x)
        else { return false }

        return true
    }
}
