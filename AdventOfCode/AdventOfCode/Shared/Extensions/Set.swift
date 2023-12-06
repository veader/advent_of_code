//
//  Set.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/6/23.
//

import Foundation

extension Set where Element == Int {
    /// Create a `ClosedRange` based on the lower and upper bounds of the values within the Set.
    var closedRange: ClosedRange<Element>? {
        guard let start = self.min(), let end = self.max() else { return nil }
        return start...end
    }
}
