//
//  DaySixteen.swift
//  aoc2019
//
//  Created by Shawn Veader on 12/16/19.
//  Copyright © 2019 Shawn Veader. All rights reserved.
//

import Foundation

struct FFT {
    static let pattern: [Int] = [1, 0, -1, 0] // "base" pattern

    @discardableResult
    static func process(input: inout [Int], phases: Int, size: Int = 8, offset: Int = 0) -> [Int] {
        var iterations = 0
        while iterations < phases {
            phase(input: &input, size: size, offset: offset)
            iterations += 1
        }

        return input
    }

    @discardableResult
    static func phase(input: inout [Int], size: Int = 8, offset: Int = 0) -> [Int] {
        // edit the input in place (save memory allocations)
        // let maxIdx = min(offset + size, input.count)
        let maxIdx = input.count
        print("Phase running over \(offset..<maxIdx)")
        for idx in (offset..<maxIdx) {
            input[idx] = phaseDigit(at: idx, stepSize: idx + 1, input: input)
        }

        return input
    }

    static private func phaseDigit(at offset: Int, stepSize: Int, input: [Int]) -> Int {
        var patternIdx = 0
        let numberOfSteps = input.count / stepSize

        let output = (0..<numberOfSteps).reduce(0) { result, chunkIdx -> Int in
            let idx = offset + (chunkIdx * stepSize)
            let multiplier = pattern[patternIdx]
            patternIdx = nextPatternIndex(patternIdx) // move to the next index for the next cycle
            return result + sum(offset: idx, stepSize: stepSize, multiplier: multiplier, input: input)
        }

        return abs(output) % 10
    }

    static private func sum(offset: Int, stepSize: Int, multiplier: Int, input: [Int]) -> Int {
        guard multiplier != 0 else { return 0 }
        let maxIdx = min((offset + stepSize), input.count) // don't fall off the end

        return input[offset..<maxIdx].reduce(0) { result, value -> Int in
            return result + (value * multiplier)
        }
    }

    static private func nextPatternIndex(_ idx: Int) -> Int {
        (idx + 1) % pattern.count
    }


    // -------------------------

    static func process1(input: [Int], phases: Int) -> [Int] {
        var iterations = 0
        var output: [Int] = input

        while iterations < phases {
            output = phase1(input: output)
            iterations += 1
        }

        return output
    }

    static func phase1(input: [Int]) -> [Int] {
        input.enumerated().map { tuple -> Int in
            phase1(digit: tuple.offset + 1, input: input)
        }
    }

    static private func phase1(digit: Int, input: [Int]) -> Int {
        let repeatingPattern = FFT.pattern.flatMap { Array(repeating: $0, count: digit) }

        let output = input.enumerated().map { (idx, int) -> Int in
            if idx + 1 < digit {
                return 0
            } else {
                // calculate pattern multiplier
                let multiplierIdx = max(0, idx - (digit - 1)) % repeatingPattern.count
                let multiplier = repeatingPattern[multiplierIdx]
                return int * multiplier
            }
        }
        var answer = output.reduce(0, +)
        answer = abs(answer) % 10
        return answer
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
        let output = FFT.process1(input: parse(input ?? ""), phases: 100)
        print("End: \(Date())")
        let outputStr = output.prefix(8).map(String.init).joined()
        return outputStr
    }

    func partTwo(input: String?) -> Any {
        print("Start: \(Date())")
        let massInput = Array(repeating: input ?? "", count: 10_000).joined()
        var signal = parse(massInput)
        print("Signal size: \(signal.count)")
        let offset = Int(String(signal.prefix(7).map(String.init).joined())) ?? 0
        print("Offset: \(offset)")
        print("Start Processing: \(Date())")
        let output = FFT.process(input: &signal, phases: 100, size: 8, offset: offset)
//        let offsetOutput = output.dropFirst(offset)
//        let outputStr = offsetOutput.prefix(8).map(String.init).joined()
        let outputStr = output[offset..<(offset+8)].compactMap(String.init).joined()
        print("End: \(Date())")
        return outputStr
    }
}
