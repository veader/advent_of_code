//
//  DayOne2022.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/1/22.
//

import Foundation

struct DayOne2022: AdventDay {
    var year = 2022
    var dayNumber = 1
    var dayTitle = "Calorie Counting"
    var stars = 0

    struct HungryElf {
        let id = UUID()
        let snacks: [Int]

        var totalCalories: Int {
            snacks.reduce(0, +)
        }
    }

    func parse(_ input: String?) -> [HungryElf] {
        var snacks = [Int]()
        var elves = [HungryElf]()

        var inputScan = input ?? ""
        while(!inputScan.isEmpty) {
            if let idx = inputScan.firstIndex(of: "\n") {
                let prefix = String(inputScan.prefix(upTo: idx))
                inputScan.trimPrefix(prefix)
                inputScan.remove(at: inputScan.startIndex) // remove the newline

                if let snack = Int(prefix) {
                    snacks.append(snack)
                } else { // new line
                    elves.append(HungryElf(snacks: snacks))
                    snacks = []
                }
            } else {
                // last line?
                if let snack = Int(inputScan) {
                    snacks.append(snack)
                }
                elves.append(HungryElf(snacks: snacks))
                snacks = []
                break
            }
        }

        return elves
    }

    func partOne(input: String?) -> Any {
        let elves = parse(input)
        let maxElf = elves.max(by: { $0.totalCalories < $1.totalCalories })
        return maxElf?.totalCalories ?? 0
    }

    func partTwo(input: String?) -> Any {
        let elves = parse(input).sorted(by: { $0.totalCalories > $1.totalCalories })
        let topThree = elves.prefix(upTo: 3)
        return topThree.reduce(0, { $0 + $1.totalCalories })
    }
}
