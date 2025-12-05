//
//  ClosedRange.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/5/23.
//

import Foundation

extension ClosedRange where Bound == Int  {
    typealias RangeParts = (before: ClosedRange?, overlap: ClosedRange?, after: ClosedRange?)
    
    /// How does the given range intersect with this range?
    ///
    /// Split up the ranges such that it is possible to understand how the ranges overlap.
    ///
    /// ```
    /// Examples:
    /// 0...10, 11...20 : Don't overlap -> nil
    /// 0...10, 0...10  : Same -> (before: nil, overlap: 0...10, after: nil)
    /// 0...10, 5...15  : Overlap -> (before: 0...4, overlap: 5...10, after: 11...15)
    /// 0...10, 4...6   : Contained -> (before: 0...3, overlap: 4...6, after: 7...10)
    /// 0...10, 0...5   : Overlap (start) -> (before: nil, overlap: 0...5, after: 6...10)
    /// 0...10, 5...10  : Overlap (end) -> (before: 0...4, overlap: 5...10, after: nil)
    /// ```
    ///
    /// - Returns: Tuple with (optional) before, overlap, and after ranges.
    func intersections(with range: ClosedRange<Bound>) -> RangeParts? {
        guard overlaps(range) else { return nil }

        if self == range {
            return (nil, self, nil)
        }

        let selfSet = Set<Bound>(self)
        let rangeSet = Set<Bound>(range)

        let overlap = selfSet.intersection(rangeSet).closedRange
        let minusRange = selfSet.subtracting(rangeSet).closedRange
        let minusSelf = rangeSet.subtracting(selfSet).closedRange

        let ranges = [minusRange, minusSelf, overlap].compactMap({ $0 }).sorted { ($0?.min() ?? 0) <= ($1?.min() ?? 0) }

        if overlap == range, minusRange == self {
            // given range is completely inside this range
            return (
                lowerBound...(range.lowerBound - 1),
                range,
                (range.upperBound + 1)...upperBound
            )
        } else if overlap == self, minusSelf == range {
            // this range is completely inside the given range
            return (
                range.lowerBound...(lowerBound - 1),
                self,
                (upperBound + 1)...range.upperBound
            )
        } else if ranges.count == 3 {
            return (ranges[0], ranges[1], ranges[2])
        } else if ranges.count == 2 {
            if range.lowerBound == lowerBound {
                // no before
                return (nil, ranges[0], ranges[1])
            } else if range.upperBound == upperBound {
                // no after
                return (ranges[0], ranges[1], nil)
            } else {
                print("🤯 What caused this? \(#function):\(#line) -> \(self) intersect \(range)")
            }
        }

        return nil
    }

    /// Merge two overlapping ranges.
    ///
    /// If the ranges to not overlap, nil is returned.
    func merging(with range: ClosedRange<Bound>) -> ClosedRange<Bound>? {
        guard self.overlaps(range) else { return nil }

        let start = [self.lowerBound, range.lowerBound].min() ?? 0
        let end = [self.upperBound, range.upperBound].max() ?? 0

        return (start...end)

//        let selfSet = Set<Bound>(self)
//        let rangeSet = Set<Bound>(range)
//
//        let intersection = selfSet.intersection(rangeSet)
//        guard !intersection.isEmpty else { return nil } // ranges do not intersect, can't merge
//
//        return selfSet.union(rangeSet).closedRange
    }
}
