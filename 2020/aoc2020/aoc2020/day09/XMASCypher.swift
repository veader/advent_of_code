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

    func findWeakness() -> Int {
        var preableRange: Range<Int> = 0..<preamble // Range for the preamble window
        var idx = preamble

        while data.indices.contains(idx) {
            // print("Checking that \(data[idx]) @ \(idx) is valid with preamble: \(Array(data[preableRange]))")
            guard isValid(data[idx], preable: Array(data[preableRange])) else { break }

            // move window and index up one
            preableRange = (preableRange.lowerBound + 1)..<(preableRange.upperBound + 1)
            idx += 1
        }

        return data[idx]
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
