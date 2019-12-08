//
//  Array.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/8/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

extension Array {
    /// Return a new collection removing the element at the given index.
    /// - parameters:
    ///     - index: Index of element to remove from the returned collection
    /// - returns: New collection with the given element removed.
    func removing(index: Int) -> [Element] {
        var copy = self
        copy.remove(at: index)
        return copy
    }

    /// Split the array into even sized pieces.
    /// - parameters:
    ///     - size: Size of the chunks
    /// - returns: An array of chunks of the given size.
    func chunks(size: Int) -> [[Element]] {
        stride(from: startIndex, to: endIndex, by: size).map { idx -> [Element] in
            let startIdx = distance(from: startIndex, to: idx)
            return Array<Element>(self[startIdx..<(startIdx + size)])
        }
    }
}
