//
//  DaySixteen.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/16/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct FFT {
    var pattern: [Int] = [1, 0, -1, 0] // "base" pattern

    func process(input: [Int], phases: Int) -> [Int] {
        var iterations = 0
        var output: [Int] = input

        while iterations < phases {
            output = phase(input: output)
            iterations += 1
        }

        return output
    }


    func phase(input: [Int]) -> [Int] {
        let output = input.enumerated().map { tuple -> Int in
            phase(digit: tuple.offset + 1, input: input)
        }
        // print(output)

        return output
    }

    private func phase(digit: Int, input: [Int]) -> Int {
        // var outputText: [String] = [String]()
        let repeatingPattern = pattern.flatMap { Array(repeating: $0, count: digit) }
        // print(repeatingPattern)

        let output = input.enumerated().map { (idx, int) -> Int in
            if idx + 1 < digit {
                // outputText.append("\(int)*0")
                return 0
            } else {
                // calculate pattern multiplier
                let multiplierIdx = max(0, idx - (digit - 1)) % repeatingPattern.count
                let multiplier = repeatingPattern[multiplierIdx]
                // outputText.append("\(int)*\(multiplier)[\(multiplierIdx)]")
                return int * multiplier
            }
        }
        let answer = output.reduce(0, +)
        let answerText = "\(answer)".suffix(1)
        // print(outputText.joined(separator: " + ") + " = \(answerText)")
        return Int(answerText) ?? 0
    }
}

struct DaySixteen: AdventDay {
    var dayNumber: Int = 16

    func parse(_ input: String?) -> [Int] {
        (input ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .compactMap { Int(String($0)) }
    }

    func partOne(input: String?) -> Any {
        print("Start: \(Date())")
        let output = FFT().process(input: parse(input ?? ""), phases: 100)
        print("End: \(Date())")
        let outputStr = output.prefix(8).map(String.init).joined()
        return outputStr
    }

    func partTwo(input: String?) -> Any {
        return 0
    }
}
