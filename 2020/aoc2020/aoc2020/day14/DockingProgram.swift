//
//  DockingProgram.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/14/20.
//

import Foundation

class DockingProgram {
    var memory: [Int: Int] = [Int: Int]()

    var memorySum: Int {
        memory.values.reduce(0, +)
    }

    func initialize(_ input: String?, version: Int = 1) {
        var mask: String = "".padded(with: "X", length: 36) // blank initial mask

        let maskRegex = "mask = ([X10]*)"
        let memAddrRegex = "mem\\[([0-9]*)\\] = ([0-9]*)"

        let lines = input?.split(separator: "\n").map(String.init) ?? []
        for line in lines {
            if let match = line.matching(regex: maskRegex), let newMask = match.captures.first {
                // print("NEW MASK: \(newMask)")
                mask = newMask
            } else if let match = line.matching(regex: memAddrRegex) {
                guard
                    let memAddrStr = match.captures.first,
                    let memAddr = Int(memAddrStr),
                    let memValueStr = match.captures.last,
                    let memValue = Int(memValueStr)
                    else {
                        print("Something went wrong: \(match)")
                        break
                    }

                if version == 2 {
                    let addresses = memoryDecoder(addrMask: memAddr.masked(with: mask))
                    // print("ASSIGN MEM: @\(addresses) = \(memValue)")
                    for addr in addresses {
                        memory[addr] = memValue
                    }
                } else {
                    // print("ASSIGN MEM: @ \(memAddr)")
                    memory[memAddr] = memValue.applying(mask: mask)
                }
            } else {
                print("Unknown line: \(line)")
            }
        }
    }

    /// Return all possible memory addresses after decoding the memory address mask.
    func memoryDecoder(addrMask: String) -> [Int] {
        mutateAddress(addrMask).compactMap { Int($0, radix: 2) }
    }

    /// Return all mutations of the given address by swapping any values of `X` with `0` and `1` and recursing...
    private func mutateAddress(_ address: String) -> [String] {
        guard let swapIdx = address.firstIndex(of: "X") else { return [address] } // no more values to swap...

        var swappableAddr = address

        return (0...1).flatMap { value -> [String] in
            swappableAddr.replaceSubrange(swapIdx...swapIdx, with: [Character(String(value))])
            return mutateAddress(swappableAddr)
        }
    }
}
