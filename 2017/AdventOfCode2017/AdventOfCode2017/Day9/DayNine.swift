//
//  DayNine.swift
//  AdventOfCode2017
//
//  Created by Shawn Veader on 12/9/17.
//  Copyright © 2017 v8logic. All rights reserved.
//

import Foundation

struct DayNine: AdventDay {

    struct Garbage: CustomDebugStringConvertible {
        let content: String
        let notCanceled: String

        /// Parse input finding "garbage" data. eg: <...>
        static func parse(_ input: String) -> (Garbage?, Int?) {
            guard input.first == "<" else { return (nil, nil) }

            var content = ""
            var notCanceled = ""
            var notStatus = true // status based on number of ! found

            for (idx, char) in input.enumerated() {
                // skip over opening "<"
                guard idx > 0 else { continue }

                switch char {
                case ">":
                    if notStatus == true {
                        // found the end of the garbage
                        return (Garbage(content: content, notCanceled: notCanceled), idx)
                    } else {
                        content.append(char)
                        notStatus = true // reset
                    }
                case "!":
                    notStatus = !notStatus // invert not status
                    content.append(char)
                default:
                    content.append(char)
                    if notStatus == true {
                        notCanceled.append(char)
                    }
                    notStatus = true // any non-! char resets
                }
            }

            print("🤔 How did we get here in the garbage parsing?\n\(input)")
            return (nil, nil)
        }

        var debugDescription: String {
            return "<\(content)>"
        }
    }

    struct Group: CustomDebugStringConvertible {
        let level: Int
        let subGroups: [Group]
        let garbagePiles: [Garbage]

        var score: Int {
            return level + subGroups.reduce(0, { result, group in
                result + group.score
            })
        }

        var removedCount: Int {
            return garbagePiles.reduce(0, { result, garbage in
                result + garbage.notCanceled.count
            }) + subGroups.reduce(0, { result, group in
                result + group.removedCount
            })
        }

        /// Parse input finding "groups" (with nested sub-groups and garbage) until the closing }
        static func parse(_ input: String, level: Int = 1) -> (Group?, Int?) {
            // print("Parsing Group: \(input)")
            guard input.first == "{" else { return (nil, nil) }

            var content = ""
            var subGroups = [Group]()
            var garbagePiles = [Garbage]()

            var nextIndex: Int?

            for (idx, char) in input.enumerated() {
                // skip over opening "{"
                guard idx > 0 else { continue }

                // skip everything until the next index, if we have one.
                if let nextIndex = nextIndex, idx < nextIndex {
                    continue
                }
                // nextIndex = nil // make sure we clear out next index - is this needed?

                switch char {
                case "}":
                    // end of our group.
                    return (Group(level: level, subGroups: subGroups, garbagePiles: garbagePiles), idx)
                case "{":
                    // start of a sub-group. recurse in with the string starting at this point
                    let subGroupStartIndex = input.index(input.startIndex, offsetBy: idx)
                    let subGroupInput = String(input[subGroupStartIndex...])
                    let (subGroup, endIndex) = Group.parse(subGroupInput, level: level + 1)

                    if let endIndex = endIndex {
                        nextIndex = idx + endIndex + 1 // in this loop, skip all chars until we hit this index
                    }

                    if let subGroup = subGroup {
                        subGroups.append(subGroup)
                    }
                case "<":
                    // start of garbage.
                    let garbageStartIndex = input.index(input.startIndex, offsetBy: idx)
                    let garbageInput = String(input[garbageStartIndex...])

                    let (garbage, endIndex) = Garbage.parse(garbageInput)

                    if let endIndex = endIndex {
                        nextIndex = idx + endIndex + 1 // in this loop, skip all chars until we hit this index
                    }

                    if let garbage = garbage {
                        garbagePiles.append(garbage)
                    }
                default:
                    // gather content
                    content.append(char)
                }
            }

            print("🤔 How did we get here in the group parsing?\nINPUT: \(input)\nCONTENT:\(content)")
            return (nil, nil)
        }

        var debugDescription: String {
            let nesting = String(repeating: "\t", count:level - 1)
            return """
                \(nesting)Group({
                \(nesting)    Level: \(level)
                \(nesting)    Garbage: (\(garbagePiles.map{ String(describing: $0) }.joined(separator: ",")))
                \(nesting)    Groups: \(subGroups.count)
                \(subGroups.map { String(describing: $0) }.joined(separator: "\n"))
                \(nesting)})
                """
        }
    }


    // MARK: -

    func defaultInput() -> String? {
        let path = "\(dataPath())/day9input.txt"
        return try? String(contentsOfFile: path, encoding: .utf8)
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day 9: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day 9: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 9: (Part 1) Answer ", answer)

        let thing2 = partTwo(input: runInput)
        guard let answer2 = thing2 else {
            print("Day 9: (Part 2) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day 9: (Part 2) Answer ", answer2)
    }

    // MARK: -

    func partOne(input: String) -> Int? {
        let (group, _) = Group.parse(input)
        guard let theGroup = group else { return nil }
        return theGroup.score
    }

    func partTwo(input: String) -> Int? {
        let (group, _) = Group.parse(input)
        guard let theGroup = group else { return nil }
        return theGroup.removedCount
    }
}

