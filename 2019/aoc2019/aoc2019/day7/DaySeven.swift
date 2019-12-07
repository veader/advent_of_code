//
//  DaySeven.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/7/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct Amp {
    let phase: Int
    let memory: [Int]

    mutating func process(signal input: Int) -> Int {
        var machine = IntCodeMachine(memory: memory)
        machine.inputs = [phase, input]
        machine.run()

        if case .finished(output: let output) = machine.state {
            return output
        } else {
            print("Machine not in finished state... \(machine.state)")
            return -1
        }
    }
}

struct AmpCircuit {
    let memory: [Int]
    let sequence: [Int]

    func process() -> Int {
        return sequence.reduce(0) { input, phase -> Int in
            var amp = Amp(phase: phase, memory: memory)
            return amp.process(signal: input)
        }
    }
}

extension Array {
    /// Return a new sequence removing the element at the given index.
    func removing(index: Int) -> [Element] {
        var copy = self
        copy.remove(at: index)
        return copy
    }
}

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
        return max(mutating: Array(0..<5), memory: memory)
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
