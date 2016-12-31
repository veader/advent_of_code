#!/usr/bin/env swift

import Foundation

// ----------------------------------------------------------------------------
struct Elf {
    let index: Int
    var presentCount: Int
}

extension Elf: Comparable { }
func <(lhs: Elf, rhs: Elf) -> Bool {
    return lhs.index < rhs.index
}
func ==(lhs: Elf, rhs: Elf) -> Bool {
    return lhs.index == rhs.index
}

extension Elf: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Elf(index: \(index) [\(index + 1)], presents: \(presentCount))"
    }
}

// ----------------------------------------------------------------------------
struct ElfCircle {
    var elves: [Elf]

    init(count: Int) {
        // we only really need odd elves
        elves = stride(from: 0, to: count, by: 2).map {
            return Elf.init(index: $0, presentCount: 2)
        }

        // if count is odd, the last one will take from 1
        if count % 2 != 0 {
            if let lastElf = elves.last, let firstElf = elves.first {
                // var theLast = lastElf
                let presents = firstElf.presentCount + 1
                // theLast.presentCount = presents

                // elves[elves.endIndex - 1] = theLast
                elves[elves.endIndex - 1] = Elf.init(index: lastElf.index, presentCount: presents)
                elves.removeFirst() // first index now has 0
            }
        }

        // elves = (0..<elfCount).map { Elf.init(index: $0) }
    }

    mutating func exchangePresents() {
        print("Exchanging Presents...")
        while elves.count > 1 {
            print("\(elves.count) Elves Remaining")
            (0..<elves.count).forEach { idx in
                var thisElf = elves[idx]
                if thisElf.presentCount == 0 { return }

                var leftElf = nextElf(after: idx)
                if leftElf == nil { return }

                if leftElf!.index == thisElf.index { return }

                let presents = leftElf!.presentCount
                // print("Elf \(thisElf.index + 1) taking \(presents) presents from Elf \(leftElf!.index + 1)")

                thisElf.presentCount += presents
                leftElf!.presentCount = 0

                // save back to the array
                elves[idx] = thisElf
                if let leftIndex = elves.index(where: { $0.index == leftElf!.index }) {
                    elves[leftIndex] = leftElf!
                }
            }

            let elvesWithPresents = elves.filter { $0.presentCount > 0 }
            elves = elvesWithPresents.sorted()
        }
    }

    func nextElf(after index: Int) -> Elf? {
        guard elves.count > 1 else { return nil }
        // look for the next elf that has a non-zero present count
        let nextIndex = elves.index(after: index)
        if nextIndex == elves.endIndex {
            return elves.first
        } else {
            return elves[nextIndex]
        }
    }
}

extension ElfCircle: CustomDebugStringConvertible {
    var debugDescription: String {
        var desc = "ElfCircle(\n"
        elves.forEach { desc += "  \($0.debugDescription)\n" }
        desc += ")\n"
        return desc
    }
}
// ----------------------------------------------------------------------------
let elfCount = 11119 //3014387
print("Starting with \(elfCount) Elves")
var circle = ElfCircle.init(count: elfCount)
// print(circle)
circle.exchangePresents()
// print("\n")
print(circle)
