//
//  DaySeven.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/7/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct DaySeven: AdventDay {
    var dayNumber: Int = 7

    func mutations(of sequence: [Int]) -> [[Int]] {
        guard sequence.count > 1 else { return [sequence] }

        return sequence.indices.flatMap { idx -> [[Int]] in
            let currentValue = sequence[idx]
            let otherValues = sequence.removing(index: idx)

            return mutations(of: otherValues).map { [currentValue] + $0 }
        }
    }

    func max(mutating sequence: [Int], memory: [Int]) -> Int {
        let possibleSequences = mutations(of: sequence)
        let thrustValues = possibleSequences.map { seq -> Int in
            AmpCircuit(memory: memory, sequence: seq).process()
        }

        return thrustValues.max() ?? 0
    }

    func partOne(input: String?) -> Any {
        let memory = IntCodeMachine.parse(instructions: input ?? "")
        return max(mutating: Array(0..<5), memory: memory) // 0 -> 4
    }

    func partTwo(input: String?) -> Any {
        let memory = IntCodeMachine.parse(instructions: input ?? "")
        return max(mutating: Array(5..<10), memory: memory) // 5 -> 9
    }
}
