#!/usr/bin/env swift

import Foundation

// ----------------------------------------------------------------------------
struct Elf {
    let index: Int
    let presentCount: Int

    func elfByAddingPresents(_ count: Int) -> Elf {
        return Elf.init(index: self.index, presentCount: self.presentCount + count)
    }

    func elfWithZeroPresents() -> Elf {
        return Elf.init(index: self.index, presentCount: 0)
    }
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
                elves[elves.endIndex - 1] = lastElf.elfByAddingPresents(firstElf.presentCount + 1)
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
                let thisElf = elves[idx]
                if thisElf.presentCount == 0 { return }

                guard let leftElf = nextElf(after: idx) else { print("Couldn't find left elf"); return }
                if leftElf.index == thisElf.index { return }

                let presentsToTake = leftElf.presentCount
                // print("Elf \(thisElf.index + 1) taking \(presentsToTake) presents from Elf \(leftElf!.index + 1)")

                // set in the array
                elves[idx] = thisElf.elfByAddingPresents(presentsToTake)
                if let leftIndex = elves.index(where: { $0.index == leftElf.index }) {
                    elves[leftIndex] = leftElf.elfWithZeroPresents()
                }
            }

            let elvesWithPresents = elves.filter { $0.presentCount > 0 }
            elves = elvesWithPresents
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
let elfCount = 3014387
print("Starting with \(elfCount) Elves")
var circle = ElfCircle.init(count: elfCount)
// print(circle)
circle.exchangePresents()
// print("\n")
print(circle)
