//
//  XMASCypher.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/9/20.
//

import Foundation

class XMASCypher {
    /// Size of the cypher preamble
    let preamble: Int

    /// Data within the cypher
    let data: [Int]

    init(preamble: Int, data: [Int]) {
        self.preamble = preamble
        self.data = data
    }

    /// Find the weakness in the cypher by locating a number in the series that can not
    ///     be made by summing 2 numbers in the preceeding numbers (determined by the
    ///     preamble size).
    func findWeakness() -> Int {
        var preableRange: Range<Int> = 0..<preamble // Range for the preamble window
        var idx = preamble

        while data.indices.contains(idx) {
            guard isValid(data[idx], preable: Array(data[preableRange])) else { break }

            // move window and index up one
            preableRange = (preableRange.lowerBound + 1)..<(preableRange.upperBound + 1)
            idx += 1
        }

        return data[idx]
    }

    func findWeaknessRange(target: Int) -> [Int]? {
        var weakness: [Int]?

        for idx in data.indices {
            //print("\nIndex: \(idx)")
            let dataSlice = data.suffix(from: idx)
            let subIndicies = dataSlice.indices
            //print("Sub Indicies: \(subIndicies)")
            let answer = dataSlice.indices.prefix { subIdx -> Bool in
                guard let first = subIndicies.first, subIdx != first else { return true } // ignore the first index
                //print("Sub Index: \(subIdx)")
                let range = data[first..<subIdx]
                let sum = range.reduce(0, +)
                //print("Range: \(range) Sum: \(sum)")
//                if sum == target {
//                    print(" ----- FOUND IT! \(target)")
//                    print("Returning \(range)...")
//                }
                return sum < target
                // return true
            }

            let subSet = Array(data[answer])
            let sum = subSet.reduce(0, +)
            if sum == target {
                weakness = subSet
                break
            }
        }

        return weakness
    }

    func isValid(_ int: Int, preable: [Int]) -> Bool {
        possibleSums(preable).contains(int)
    }

    func possibleSums(_ ints: [Int]) -> [Int] {
        ints.enumerated().flatMap { (idx, value) -> [Int] in
            ints.suffix(ints.count - (idx + 1)).map { $0 + value }
        }.unique()
    }
}
