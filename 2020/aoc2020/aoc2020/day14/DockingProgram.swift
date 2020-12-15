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

    func initialize(_ input: String?) {
        var mask: String = "".padded(with: "X", length: 36) // blank initial mask

        let maskRegex = "mask = ([X10]*)"
        let memAddrRegex = "mem\\[([0-9]*)\\] = ([0-9]*)"

        let lines = input?.split(separator: "\n").map(String.init) ?? []
        for line in lines {
            if let match = line.matching(regex: maskRegex), let newMask = match.captures.first {
                print("NEW MASK: \(newMask)")
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

                print("ASSIGN MEM: @ \(memAddr)")
                memory[memAddr] = memValue.applying(mask: mask)
            } else {
                print("Unknown line: \(line)")
            }
        }
    }


}
