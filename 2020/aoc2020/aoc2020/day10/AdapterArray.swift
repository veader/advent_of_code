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

    func possibleAdapterChains() -> [[Int]] {
        possiblities(for: 0, starting: 0, data: adapters.sorted(), accumulation: [0])
    }

    func possiblities(for value: Int, starting: Int, data: [Int], accumulation: [Int]) -> [[Int]] {
        let choices = data.suffix(from: starting).prefix(while: { (value...value + 3).contains($0) })
        // print("\nChoices for \(value) starting from \(starting): \(choices) | Acc: \(accumulation)")
        // print(data.suffix(from: starting))

        if choices.count == 0 {
            // print("Hit the end of the line...")
            return [accumulation + [value + 3]] // add the final joltage
        }

//        var possibilites = [[Int]]()
//        for choice in choices {
//            guard choice != value, let idx = data.firstIndex(of: choice) else { continue }
//            // print("\tChoice \(choice) @ \(idx)")
//            let subPossibilities = possiblities(for: choice, starting: idx.advanced(by: 1), data: data, accumulation: accumulation + [choice])
//            // print("\tSubPoss: \(subPossibilities)")
//            possibilites.append(contentsOf: subPossibilities)
//        }
//
//        // print("Found these possibilites for \(value) @ \(starting): \(possibilites)")
//        return possibilites

        return choices.flatMap { (choice: Int) -> [[Int]] in
            guard choice != value, let idx = data.firstIndex(of: choice) else { return [] }
            // print("\tChoice \(choice) @ \(idx)")
            return possiblities(for: choice, starting: idx.advanced(by: 1), data: data, accumulation: accumulation + [choice])
        }
    }
}
