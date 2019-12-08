//
//  DaySeven.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/7/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

class Amp {
    let phase: Int
    let memory: [Int]
    var machine: IntCodeMachine

    init(phase: Int, memory: [Int]) {
        self.phase = phase
        self.memory = memory

        machine = IntCodeMachine(memory: memory)
        machine.inputs = [phase]
    }

    func process(signal input: Int) -> Int {
        machine.set(input: input)
        machine.run()

        if case .finished(output: let output) = machine.state {
            // print("Finished with output: \(output)")
            return output
        } else if case .awaitingInput = machine.state {
            guard machine.outputs.count > 0 else {
                print("Machine awaiting input but has no output to give...")
                return -1
            }
            return machine.outputs.last ?? -1
        } else {
            print("Machine not in finished state... \(machine.state)")
            print("Available outputs: \(machine.outputs)")
            return -2
        }
    }
}

struct AmpCircuit {
    let memory: [Int]
    let sequence: [Int]

    func process() -> Int {
        // create our series of amps
        let amps = sequence.map { Amp(phase: $0, memory: memory) }
        let lastAmp: Amp! = amps.last // a bit dangerous

        var signal = 0 // start with 0
        var finished = false

        while !finished {
            amps.forEach { amp in
                signal = amp.process(signal: signal)
            }

            if case .finished(_) = lastAmp.machine.state {
                finished = true
            }
        }

        return signal
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
        return max(mutating: Array(0..<5), memory: memory) // 0 -> 4
    }

    func partTwo(input: String?) -> Any {
        let memory = IntCodeMachine.parse(instructions: input ?? "")
        return max(mutating: Array(5..<10), memory: memory) // 5 -> 9
    }
}
