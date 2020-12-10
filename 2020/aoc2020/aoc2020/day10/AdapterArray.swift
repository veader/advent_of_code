//
//  AdapterArray.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/10/20.
//

import Foundation

struct AdapterArray {
    let adapters: [Int]

    func adapterChain() -> (joltage: Int, chain: [Int], deltaOne: Int, deltaThree: Int) {
        var oneDeltas = 0
        var threeDeltas = 0
        var chain = [Int]()
        var currentJoltage = 0 // charging outlet has 0 jolts

        var joltAdapters = adapters.sorted()

        while !joltAdapters.isEmpty {
            guard let idx = joltAdapters.firstIndex(where: { (currentJoltage...currentJoltage+3).contains($0) }) else {
                print("Unable to find adapter that will handle \(currentJoltage) jolts")
                break
            }

            let adapter = joltAdapters.remove(at: idx)

            let delta = adapter - currentJoltage
            switch delta {
            case 1:
                oneDeltas += 1
            case 3:
                threeDeltas += 1
            default:
                print("Unknown delta \(delta)")
            }

            chain.append(adapter)
            currentJoltage = adapter
        }

        // device can handle + 3
        threeDeltas += 1
        currentJoltage += 3

        return (currentJoltage, chain, oneDeltas, threeDeltas)
    }
}
