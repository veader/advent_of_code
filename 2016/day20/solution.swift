#!/usr/bin/env swift

import Foundation

extension UInt32 {
    func dotDecimalNotation() -> String {
        let max: UInt32 = UInt32.max
        let firstQuadMask:  UInt32 = max << 24
        let secondQuadMask: UInt32 = firstQuadMask  >> 8
        let thirdQuadMask:  UInt32 = secondQuadMask >> 8
        let fourthQuadMask: UInt32 = thirdQuadMask  >> 8

        let firstQuad  = (self & firstQuadMask)  >> 24
        let secondQuad = (self & secondQuadMask) >> 16
        let thirdQuad  = (self & thirdQuadMask)  >> 8
        let fourthQuad = (self & fourthQuadMask)

        return "\(firstQuad).\(secondQuad).\(thirdQuad).\(fourthQuad)"
    }
}

// ----------------------------------------------------------------------------
// returns the lines out of the input file
func readInputData() -> [String] {
    guard let currentDir = ProcessInfo.processInfo.environment["PWD"] else {
        print("No current directory.")
        return []
    }

    let inputPath = "\(currentDir)/input.txt"
    do {
        let data = try String(contentsOfFile: inputPath, encoding: .utf8)
        let lines = data.components(separatedBy: "\n")
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .filter { !$0.isEmpty }
        return lines
    } catch {
        return []
    }
}

// ----------------------------------------------------------------------------
// MARK: - "MAIN()"
let lines = readInputData()
var ranges = lines.map { (line: String) -> ClosedRange<UInt32> in
    let numbers: [UInt32] = line.components(separatedBy: "-").map { UInt32.init($0)! }
    return (numbers.first!...numbers.last!)
}.sorted {
    $0.lowerBound < $1.lowerBound
}

var currentIPInt: UInt32 = 1
var lowestIPInt: UInt32 = 0
while lowestIPInt == 0 {
    var foundInRanges = false
    var nextRange: ClosedRange<UInt32>? = nil

    ranges.forEach { range in
        if range.contains(currentIPInt) {
            foundInRanges = true
            if nextRange == nil {
                nextRange = range
            }
        }
    }

    if foundInRanges == false {
        lowestIPInt = currentIPInt
    }

    // skip past this matching range
    if let range = nextRange {
        currentIPInt = range.upperBound + 1
    } else {
        currentIPInt += 1
    }
}

print("Lowest IP: \(lowestIPInt) \(lowestIPInt.dotDecimalNotation())")

// let exampleInt: UInt32 = 0b10101100000100001111111000000001
// print(exampleInt.dotDecimalNotation())
