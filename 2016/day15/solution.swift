#!/usr/bin/env swift

import Foundation

// ----------------------------------------------------------------------------
struct Sculpture {
    var discs: [Disc]

    init() {
        discs = [Disc]()
    }

    mutating func setup(_ input: [String]) {
        // http://rubular.com/r/ZUoU7QpHHQ
        let inputRegex = "Disc \\#(\\d+) has (\\d+) positions\\; at time=(\\d+), it is at position (\\d+)\\."

        discs = input.flatMap { line in
            if let matches = line.matches(regex: inputRegex) {
                guard let match = matches.first else { return nil }
                guard let positionCount = Int.init(match.captures[1]) else { return nil }
                guard let offset = Int.init(match.captures[3]) else { return nil }
                return Disc.init(name: match.captures[0], positions: positionCount, offset: offset)
            }
            return nil
        }
    }

    func doesBallFall(at time: Int) -> Bool {
        var falls = true
        discs.enumerated().forEach { idx, disc in
            let timeNow = time + idx + 1 // takes one second from original time
            if !disc.open(at: timeNow) {
                falls = false
            }
        }
        return falls
    }
}

// ----------------------------------------------------------------------------
struct Disc {
    let name: String
    let positions: Int
    let offset: Int

    func open(at time: Int) -> Bool {
        let positionOffset = (time + offset) % positions
        return positionOffset == 0
    }
}

extension Disc: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Disc(#\(name) -> positions: \(positions) : offset: \(offset))"
    }
}

// ----------------------------------------------------------------------------
extension String {
    struct RegexMatch : CustomDebugStringConvertible {
        let match: String
        let captures: [String]
        let range: NSRange

        var debugDescription: String {
            return "RegexMatch( match: '\(match)', captures: [\(captures)], range: \(range) )"
        }

        init(string: String, regexMatch: NSTextCheckingResult) {
            var theCaptures: [String] = (0..<regexMatch.numberOfRanges).flatMap { index in
                let range = regexMatch.rangeAt(index)
                if let _ = range.toRange() {
                    return (string as NSString).substring(with: range)
                } else {
                    return nil
                }
            }

            match = theCaptures.removeFirst() // the 0 index is the whole string that matches
            captures = theCaptures
            range = regexMatch.range
        }
    }

    func matches(regex: String) -> [RegexMatch]? {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: .caseInsensitive)
            let wholeThing = NSMakeRange(0, characters.count)
            let regexMatches = regex.matches(in: self, options: .withoutAnchoringBounds, range: wholeThing)

            guard let _ = regexMatches.first else { return nil }

            return regexMatches.flatMap { m in
                return RegexMatch.init(string: self, regexMatch: m)
            }
        } catch {
            return nil
        }
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

var sculpt = Sculpture()
sculpt.setup(lines)
sculpt.discs.append(Disc.init(name: "11", positions: 11, offset: 0)) // for part 2

var falls = false
var time = 0

while !falls {
    falls = sculpt.doesBallFall(at: time)
    print("time=\(time): \(falls)")
    time += 1
}
