//
//  GridMap.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/9/21.
//

import Foundation

class GridMap<Element> {
    var items: [[Element]]
    var xBounds: Range<Int>
    var yBounds: Range<Int>

    init(items: [[Element]]) {
        self.items = items
        self.xBounds = 0..<(items.first ?? []).count
        self.yBounds = 0..<items.count
    }


    // MARK: -

    /// Width of the map based on X coordinate space
    var width: Int {
        xBounds.count
    }

    /// Height of the map based on Y coordinate space
    var height: Int {
        yBounds.count
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

    /// Return a column at the given x offset.
    func column(x: Int) -> [Element]? {
        guard xBounds.contains(x) else { return nil }
        return yBounds.compactMap { itemAt(x: x, y: $0) }
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

    /// Insert a row in the grid filled with the given element. All other items beyond this are shifted.
    ///
    /// - Note: New y must be within or along edge of current bounds.
    func insertRow(at y: Int, value: Element) {
        // TODO: should this throw?
        guard yBounds.contains(y) || yBounds.upperBound == y else { return }

        yBounds = yBounds.lowerBound..<(yBounds.upperBound + 1) // expand our bounds

        // start by putting an empty row at the end
        var currentY = yBounds.upperBound - 1
        items.append([])

        // next copy the row below into the current row
        while currentY != y {
            guard let rowToMove = row(y: currentY - 1) else { continue }
            items[currentY] = rowToMove
            currentY -= 1 // move down another row
        }

        // now place empty row at the appropriate spot
        items[y] = Array(repeating: value, count: xBounds.count)
    }

    /// Insert a column in the grid filled with the given element. All other items beyond this are shifted.
    ///
    /// - Note: New x must be within or along edge of current bounds.
    func insertColumn(at x: Int, value: Element) {
        // TODO: should this throw?
        guard xBounds.contains(x) || xBounds.upperBound == x else { return }

        xBounds = xBounds.lowerBound..<(xBounds.upperBound + 1) // expand our bounds

        // start by putting an empty column at the end
        var currentX = xBounds.upperBound - 1
        yBounds.forEach { items[$0].append(value) }

        // next copy the column before into the current column
        while currentX != x {
            guard xBounds.contains(currentX - 1) else { continue }
            for y in yBounds {
                guard let item = itemAt(x: currentX - 1, y: y) else { continue }
                update(at: Coordinate(x: currentX, y: y), with: item)
            }
            currentX -= 1 // move over another row
        }

        // now place the empty column at the appropriate spot
        for y in yBounds {
            update(at: Coordinate(x: x, y: y), with: value)
        }
    }

    /// Return all coordinates adjacent to the given coordinate.
    func adjacentCoordinates(to coordinate: Coordinate, allowDiagonals: Bool = true) -> [Coordinate] {
        if allowDiagonals {
            return coordinate.adjacent(xBounds: ClosedRange(xBounds), yBounds: ClosedRange(yBounds))
        } else {
            return coordinate.adjacentWithoutDiagonals(xBounds: ClosedRange(xBounds), yBounds: ClosedRange(yBounds))
        }
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

    /// Is this coordinate valid within the grid's coordinate space?
    func valid(coordinate c: Coordinate) -> Bool {
        xBounds.contains(c.x) && yBounds.contains(c.y)
    }

    /// Filter the grid by mapping to the coordinate, item pair.
    /// Returns the coordinates which return true when passed to the given block.
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
    /// - Note: Careful on very large grid sizes...
    func printGrid() {
        print(gridAsString())
    }

    /// Create a string representation of the current grid.
    ///
    /// - Note: Careful on very large grid sizes...
    func gridAsString() -> String {
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

        return output.joined(separator: "\n")
    }

    func gridAsString(transform: (Element?) -> String) -> String {
        var output = [String]()
        yBounds.forEach { y in
            var row = [String]()
            xBounds.forEach { x in
                row.append(transform(itemAt(x: x, y: y)))
//                if let value = itemAt(x: x, y: y) {
//                    row.append("\(value)")
//                } else {
//                    row.append("#")
//                }
            }
            output.append(row.joined())
        }

        return output.joined(separator: "\n")

    }

    /// Iterate over all the locations in the entire grid calling the given block with
    /// the coordinate and value.
    ///
    /// - Warning: This does force unwrap `item(at:)`, you have been warned!
    func iterate(_ block: ((Coordinate, Element) -> Void)) {
        coordinates().forEach { block($0, item(at: $0)!) }
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

extension GridMap where Element: Equatable {
    /// Return the coordinates of the first item in the grid matching by the given closure.
    ///
    /// "Search" starts origin (0x0) and goes row by row.
    func first(where lambda: (Element?) -> Bool) -> Coordinate? {
        // coordinates().first(where: { lambda(item(at: $0)) })
        for y in yBounds {
            for x in xBounds {
                let c = Coordinate(x: x, y: y)
                if lambda(item(at: c)) {
                    return c
                }
            }
        }
        return nil
    }

    /// Return the number of coordinates on the map that match the given closure.
    func count(where lamda: (Element?) -> Bool) -> Int {
        var output = 0
        for y in yBounds {
            for x in xBounds {
                let c = Coordinate(x: x, y: y)
                if lamda(item(at: c)) {
                    output += 1
                }
            }
        }
        return output
    }
}
