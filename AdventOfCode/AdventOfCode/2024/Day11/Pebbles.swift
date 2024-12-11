//
//  Pebbles.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/11/24.
//

import Foundation

class Pebbles {
    var stones: [Int]

    var count: Int { stones.count }

    init(stones: [Int]) {
        self.stones = stones
    }

    subscript(index: Int) -> Int? {
        stones[index]
    }

    func blink(iterations: Int) async {
        var it = 0
        while it < iterations {
            await blink()
            it += 1
        }
    }

    func blink() async {
        var updatedStones: [[Int]] = []
        for stone in stones {
            updatedStones += [await blink(stone: stone)]
        }
        stones = updatedStones.flatMap(\.self)
    }

    func blink(stone: Int) async -> [Int] {
        let stoneString = "\(stone)"

        // 0 is replaced with 1
        if stone == 0 {
            return [1]

        // even digit lengths split in half
        } else if (stoneString.count % 2) == 0 {
            let half = stoneString.count / 2
            guard let left = Int(stoneString.prefix(half)), let right = Int(stoneString.suffix(half)) else {
                print("Unable to split \(stoneString)...")
                return []
            }
            return [left, right]

        // otherwise multiply by 2024
        } else {
            return [stone * 2024]
        }
    }
}
