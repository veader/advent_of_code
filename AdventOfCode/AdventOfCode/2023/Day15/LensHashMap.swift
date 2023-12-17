//
//  LensHashMap.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/16/23.
//

import Foundation
import OrderedCollections

class LensHashMap {
    enum HashMapOp: Equatable {
        case insert(lens: String, focal: Int)
        case remove(lens: String)
    }

    let operations: [HashMapOp]
    var hashMap: [Int: OrderedDictionary<String, Int>]

    init(_ input: String) {
        let stepStrings = (input.lines().first ?? "").split(separator: ",").map(String.init)
        operations = stepStrings.compactMap { s -> HashMapOp? in
            if let match = s.firstMatch(of: /(\w+)=(\d+)/) {
                guard let focal = Int(match.output.2) else { return nil }
                return .insert(lens: String(match.output.1), focal: focal)
            } else if let match = s.firstMatch(of: /(\w+)-/) {
                return .remove(lens: String(match.output.1))
            }

            return nil
        }

        hashMap = [:]
    }

    func process() {
        for op in operations {
            switch op {
            case .insert(lens: let lens, focal: let focal):
                let bucket = lens.simpleHash
                var currentCollection = hashMap[bucket] ?? [:]
                currentCollection[lens] = focal
                hashMap[bucket] = currentCollection
            case .remove(lens: let lens):
                let bucket = lens.simpleHash
                if let idx = hashMap[bucket]?.keys.firstIndex(of: lens) { // Note: hoping keys is always ordered too...
                    hashMap[bucket]?.remove(at: idx)
                }
            }
        }
    }

    func calculateFocalPower() -> Int {
        hashMap.keys.sorted().map { box -> Int in
            guard let collection = hashMap[box], !collection.isEmpty else { return 0 }
            return collection.enumerated().map { (idx, element) -> Int in
                (box + 1) * (idx + 1) * element.value
            }.reduce(0, +)
        }.reduce(0, +)
    }
}
