//
//  DistressSignal.swift
//  AdventOfCode
//
//  Created by Shawn Veader on 12/14/22.
//

import Foundation
import RegexBuilder

class DistressSignal {
    indirect enum PacketByte: Equatable, CustomDebugStringConvertible {
        case list([PacketByte])
        case integer(Int)

        var debugDescription: String {
            switch self {
            case .list(let nested):
                return "\(nested)".replacingOccurrences(of: " ", with: "")
            case .integer(let int):
                return "\(int)"
            }
        }
    }

    let pairs: [[PacketByte]]

    /// Create a DistressSignal populated by breaking the input into pairs of `PacketByte`.
    init(_ input: String) {
        let lines = input.split(separator: "\n").map(String.init)
        self.pairs = stride(from: 0, to: lines.count, by: 2).compactMap { idx in
            let linePairs = lines[idx..<lines.index(idx, offsetBy: 2)]
            guard linePairs.count == 2 else { return nil }

            let pair = linePairs.compactMap { line in
                var strIdx = line.startIndex
                let packet = DistressSignal.parse(packet: line, readIndex: &strIdx)
                if let packet, packet.debugDescription != line {
                    print("PARSING ERROR: \(line) != \(packet.debugDescription)")
                }
                assert((packet?.debugDescription ?? "") == line)
                return packet
            }

            guard pair.count == 2 else { return nil }
            return pair
        }
    }


    // MARK: - Compare

    func correctPairs(index: Int? = nil) -> [Int] {
        let correctness = compare(index: index)
        return correctness.enumerated().compactMap { idx, correct in
            guard correct else { return nil }
            return idx + 1
        }
    }

    func compare(index: Int? = nil) -> [Bool] {
        var pairsToConsider = pairs
        if let index, pairs.indices.contains(index) {
            pairsToConsider = [pairs[index]]
        }

        print("*** Comparing \(pairsToConsider.count) pairs...\n")
        return pairsToConsider.enumerated().map { compare(pair: $1, index: $0) }
    }

    /// Compare a pair of `PacketByte` to determine if they
    func compare(pair: [PacketByte], index: Int = 0) -> Bool {
        guard pair.count == 2 else { print("Unbalanced 'pair'..."); return false }
        print("== Pair \(index + 1) ==")
        let answer = compare(left: pair[0], right: pair[1])
        print("**** In order? \(answer)\n")
        return answer
    }

    func compare(left: PacketByte, right: PacketByte, level: Int = 0) -> Bool {
        let shouldPrint = true
        let padding = Array(repeating: "\t", count: level).joined()
        let nestedPadding = padding + "\t"
        if shouldPrint { print("\(padding)- Compare \(left) vs \(right)") }

        guard case .list(let leftList) = left, case .list(let rightList) = right else {
            print("\(nestedPadding)Something is wrong... \(left) vs \(right)")
            return false
        }

        if shouldPrint {
            let indent = "\(padding)\t\t"
            print("\(padding)\t@ Left: \(leftList.count) vs Right: \(rightList.count)")

            print("\(padding)\tLeft:")
            for thing in leftList {
                print("\(indent)\(thing)")
            }
            print("\(padding)\tRight:")
            for thing in rightList {
                print("\(indent)\(thing)")
            }
        }

        var idx = 0
        while idx < leftList.count && idx < rightList.count {
            let leftItem = leftList[idx]
            let rightItem = rightList[idx]

            switch (leftItem, rightItem) {
            case (.integer(let leftInt), .integer(let rightInt)):
                if shouldPrint { print("\(nestedPadding)- Compare \(leftInt) vs \(rightInt)") }
                if leftInt < rightInt {
                    if shouldPrint { print("\(nestedPadding)\t- Left side is smaller, inputs in order") }
                    return true // smaller number must be on the left
                } else if leftInt > rightInt {
                    if shouldPrint { print("\(nestedPadding)\t- Right side is smaller, inputs are NOT in order") }
                    return false // packets out of order
                }
                // otherwise, continue checking (values are equal)
            case (.list(_), .list(_)):
                // recurse in...
                if compare(left: leftItem, right: rightItem, level: level + 1) == false {
                    return false
                }
                // otherwise, continue checking (nested lists equal)
            case (.list(_), .integer(_)):
                if shouldPrint { print("\(nestedPadding)- Mixed types; convert right: \(leftItem) vs \(rightItem)") }
                if compare(left: leftItem, right: .list([rightItem]), level: level + 1) == false {
                    return false
                }
                // otherwise, continue checking (nested lists equal)
            case (.integer(_), .list(_)):
                if shouldPrint { print("\(nestedPadding)- Mixed types; convert left: \(leftItem) vs \(rightItem)") }
                if compare(left: .list([leftItem]), right: rightItem, level: level + 1) == false {
                    return false
                }
                // otherwise, continue checking (nested lists equal)
            }

            idx += 1
        }

        if (leftList.count - idx) == 0 {
            if shouldPrint { print("\(nestedPadding)- Left side ran out of items, inputs in order.") }
            return true
        } else if (rightList.count - idx) == 0  {
            if shouldPrint { print("\(nestedPadding)- Right side ran out of items, inputs are NOT in order.") }
            return false
        }

        return true
    }


    // MARK: - Static

    /// Parse the given input attempting to create a `PacketByte`
    static func parse(packet pktString: String, readIndex: inout String.Index) -> PacketByte? {
        guard pktString[readIndex] == "[" else { return nil }
        readIndex = pktString.index(after: readIndex) // move to next index

        var packetContents = [PacketByte]()

        while readIndex < pktString.endIndex {
//            print("Char at current index: \(pktString[readIndex]) @ \(pktString.distance(from: pktString.startIndex, to: readIndex))")
            if pktString[readIndex] == "[" {
//                print("\tNested...")
                // read nested packet
                if let nested = parse(packet: pktString, readIndex: &readIndex) {
                    packetContents.append(nested)
                }
            } else if pktString[readIndex] == "]" {
//                print("\tAt end...")
                // end of this packet: move "cursor" and return current packet
                readIndex = pktString.index(after: readIndex) // move to next index
                return .list(packetContents)
            } else if pktString[readIndex] == "," {
//                print("\tFound comma...")
                // comma found between lists
                readIndex = pktString.index(after: readIndex) // move to next index
            } else if let match = pktString.suffix(from: readIndex).firstMatch(of: nestedIntRegex) {
                if let digit = Int(match.1) {
                    packetContents.append(.integer(digit))
                }
//                print("Matching number \(match) : \(match.output) : \(match.range) : \(match.range)")
                readIndex = match.range.upperBound // move past what we matches
//                readIndex = pktString.index(after: readIndex) // move to next index
            } else {
//                print("UNKNOWN CHAR at next index: \(pktString[readIndex]) @ \(pktString.distance(from: pktString.startIndex, to: readIndex))")
                readIndex = pktString.index(after: readIndex) // move to next index
            }

//            if readIndex < pktString.endIndex {
//                print("Char at next index: \(pktString[readIndex]) @ \(pktString.distance(from: pktString.startIndex, to: readIndex))")
//            }
        }

        return .list(packetContents)
    }

    static let nestedIntRegex = Regex {
        Capture {
            OneOrMore(.digit)
        }
        Optionally {
            ","
        }
    }
}
