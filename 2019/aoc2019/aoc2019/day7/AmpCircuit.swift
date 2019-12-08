//
//  AmpCircuit.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/8/19.
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
