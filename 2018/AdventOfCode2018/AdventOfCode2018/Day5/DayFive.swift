//
//  DayFive.swift
//  AdventOfCode2018
//
//  Created by Shawn Veader on 12/5/18.
//  Copyright © 2018 Shawn Veader. All rights reserved.
//

import Foundation

struct DayFive: AdventDay {

    var dayNumber: Int = 5

    @discardableResult func run(_ input: String? = nil, _ part: Int? = 1) -> Any {
        guard let input = input ?? defaultInput else {
            print("Day \(dayNumber): NO INPUT")
            exit(10)
        }

         if part == 1 {
            let answerText = partOne(input: input)
//            print(answerText)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answerText.count)")
            return answerText.count
         } else {
            let answer = partTwo(input: input)
            print("Day \(dayNumber) Part \(part!): Final Answer \(answer)")
            return answer
         }
    }

    func partOne(input: String) -> String {
        return fullyProcess(polymer: input)
    }

    func partTwo(input: String) -> Int {
        var mapping = [String: Int]()

        let alphabet = "abcdefghijklmnopqrstuvwzyz"
        for letter in alphabet {
            let unit = String(letter)
            let alteredPolymer = remove(unit: unit, from: input)
            let finalPolymer = fullyProcess(polymer: alteredPolymer)
            // print("Removing \(unit) -> \(finalPolymer.count)")
            mapping[unit] = finalPolymer.count
        }

        return mapping.min(by: { $0.value < $1.value })?.value ?? Int.min
    }

    func fullyProcess(polymer: String) -> String {
        var before = polymer.trimmingCharacters(in: .whitespacesAndNewlines)
        var after = parseReactions(input: before)

        while before != after {
            before = after
            after = parseReactions(input: before)
        }

        return after
    }

    /// Remove a given unit (aka: letter) from the polymer
    func remove(unit: String, from polymer: String) -> String {
        return polymer.replacingOccurrences(of: unit, with: "", options: .caseInsensitive)
    }

    /// Make a single pass over the input (polymer) and parse for reactions.
    func parseReactions(input: String) -> String {
        var output = ""

        var currentIdx = input.startIndex
        while input.index(after: currentIdx) != input.endIndex {
            let nextIdx = input.index(after: currentIdx)

            let currentChar = String(input[currentIdx])
            let nextChar = String(input[nextIdx])

            if currentChar.lowercased() == nextChar.lowercased(),
                currentChar != nextChar {

                // we have a reaction!: ignore both and move current past next
                currentIdx = input.index(after: nextIdx)

                if currentIdx == input.endIndex {
                    break
                }
            } else { // no reaction: nothing changed, check the next pair
                output.append(currentChar)
                currentIdx = nextIdx
            }
        }

        if currentIdx != input.endIndex {
            let endIdx = input.index(before: input.endIndex)
            output.append(input[endIdx])
        }

        return output
    }
}
