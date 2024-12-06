//
//  Day5_2024.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/5/24.
//

import Foundation

struct Day5_2024: AdventDay {
    var year = 2024
    var dayNumber = 5
    var dayTitle = "Print Queue"
    var stars = 1

    struct PrintInstructions {
        typealias PageOrderInstruction = (page: Int, before: Int)

        let orderInstructions: [PageOrderInstruction]
        let printBatches: [[Int]]

        func pagesAfter(_ page: Int) -> [Int] {
            orderInstructions.filter { $0.page == page }.map(\.before)
        }

        func correctBatches() -> [[Int]] {
            printBatches.filter { isBatchCorrect($0) }
        }

        func isBatchCorrect(_ batch: [Int]) -> Bool {
            for (idx, page) in batch.reversed().enumerated() {
                guard idx != 0 else { continue } // last one (first in reverse) is always good...

                let after = Set(pagesAfter(page))
                let tail = Set(batch.suffix(idx))
                if !tail.isSubset(of: after) {
                    return false
                }
            }

            return true
        }
    }

    func parse(_ input: String?) -> PrintInstructions {
        var orders = [PrintInstructions.PageOrderInstruction]()
        var batches = [[Int]]()

        let lines = (input ?? "").split(separator: "\n").map(String.init)
        for line in lines {
            if line.contains("|") {
                let parts = line.split(separator: "|").map(String.init).compactMap(Int.init)
                if let page = parts.first, let before = parts.last {
                    orders.append(PrintInstructions.PageOrderInstruction(page: page, before: before))
                }
            } else {
                let batch = line.split(separator: ",").map(String.init).compactMap(Int.init)
                if !batch.isEmpty {
                    batches.append(batch)
                }
            }
        }

        return PrintInstructions(orderInstructions: orders, printBatches: batches)
    }

    func partOne(input: String?) -> Any {
        let instructions = parse(input)
        let correctBatches = instructions.correctBatches()

        // get the middle values and add them up
        return correctBatches.map {
            $0[$0.middleIndex]
        }.reduce(0, +)
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
